# Containers 101 - Production Ready Workshop

# Introduction

This tutorial is meant for viewers of the [SlimDevOps Twitch Stream](https://www.twitch.tv/slimdevops)
and builds on the [Containers 101 Beginners Workshop](../containers101-beginners-workshop/README.md)
by introducing some best practices to get your containers images ready to ship
to production.

The workshop is a practical example based on an article we published an on dev.to.

  * [Creating Production-Ready Containers - The Basics](https://dev.to/wimpress/creating-production-ready-containers-the-basics-3k6f)

In this tutorial, we will cover:
- Running as a non-root user
- Pinning base images
- Better layer caching
- Cleaning up cached files
- Use `ENTRYPOINT` instead of `CMD`
- Using a `WORKDIR`

Out of scope for this tutorial, but potentially coming soon:
- Slimming your container
- Multi-container applications with Docker Compose
- Mounting local volumes from a container
- Shipping and testing containers via CI/CD
- Anything to do with Kubernetes 😉
- Advanced container techniques (buildpacks, multistage builds, etc.)

## Set-up
- Be on the internet (for pulling and pushing images)
- [Install Docker Desktop](https://docs.docker.com/get-docker/)

```
sudo apt -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
apt -y update
apt -y install docker-ce docker-ce-cli containerd.io
docker run hello-world
sudo groupadd docker
sudo usermod -aG docker $USER
```

- [Clone this repo into your local IDE](https://github.com/slimdevops/slim-containers)

```
git clone https://github.com/slimdevops/slim-containers
```

# Example application

Martin has a simple Python application we can use as an example:

  * https://github.com/wimpysworld/redirect-livechat

# Where we left things

Clone the project and switch to `the-ubuntu-way` branch.

```bash
git clone https://github.com/wimpysworld/redirect-livechat
git checkout the-ubuntu-way
```

This is the simple `Dockerfile` we had at the end of the 101 beginners workshop.

```Dockerfile
FROM ubuntu:latest
RUN apt -y update && apt -y upgrade
RUN apt -y install nano git
RUN apt -y install python3-minimal
COPY redirect-livechat.py .
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

# Non-root user

Since this example doesn't set a `USER` explicitly in the `Dockerfile`, Docker
runs the build and all commands as the root user. While not an issue for local development, your friendly neighbourhood SysAdmin will tell you the myriad of
issues that come with running applications as root on a server in production.
And with Docker, a new set of attack methods can arise.

Thankfully, most distro container images and major languages and frameworks have
a predefined user for running applications. For example in Node.js, the user is
just `node`. In the Ubuntu container image you have a couple of options `nobody`
and `www-data`. We'll use `www-data` as our app is a web app.

Add these lines to the `Dockerfile`

```Dockerfile
RUN chown www-data:www-data redirect-livechat.py
USER www-data
```

It should look like this:

```Dockerfile
FROM ubuntu:latest
RUN apt -y update && apt -y upgrade
RUN apt -y install nano git
RUN apt -y install python3-minimal
COPY redirect-livechat.py .
RUN chown www-data:www-data redirect-livechat.py
USER www-data
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Build a new Docker image:

```Bash
docker build -t redirect-livechat:non-root .
docker images
```

And run it. We've added `--rm` to to `docker run` since the previous workshop as
this will automatically remove the container instance when its stops running.

```Bash
docker run --rm -p 8008:8008 -it redirect-livechat:non-root -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg
```

# Pinning base images

Choosing a version number for your container is often called pinning.
While many tutorials - and even some experts - will counsel newcomers to pin
their images to the `latest` tag, which means you get whatever the most recently
updated version is, using the `latest` tag can cause issues in production.

Containers are meant to be ephemeral, meaning they can be created, destroyed,
started, stopped, and reproduced with ease and reliability. Using the `latest`
tag means there isn't a single source of truth for your container's
"bill of materials". A new version or update of a dependency could introduce
a breaking change, which may cause the build to fail somewhere in your CI/CD
pipeline.

The importance of pinning is more profound when using language ecosystem base
images such as Node. Other tutorials I've seen pin only the major version.
For example, using `node:14`. This carries the same risks as using `latest`,
as minor versions can change dependencies as well.

That said, pinning distro images will prevent flag day changes and unexpected
breakage when a new Ubuntu LTS is released.

Let's pin our base image by changing:

```Dockerfile
FROM ubuntu:latest
```

to:

```Dockerfile
FROM ubuntu:20:04
```

```Dockerfile
FROM ubuntu:20.04
RUN apt -y update && apt -y upgrade
RUN apt -y install nano git
RUN apt -y install python3-minimal
COPY redirect-livechat.py .
RUN chown www-data:www-data redirect-livechat.py
USER www-data
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Build a new Docker image:

```Bash
docker build -t redirect-livechat:pin-lts .
docker images
```

And run it.

```Bash
docker run --rm -p 8008:8008 -it redirect-livechat:pin-lts -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg
```

# Better layer caching

Docker works on the concept of layer caching. It builds images sequentially.
Layering dependencies on top of each other and only rebuilding them when
something in the layer has changed.

Layer 0 in a Docker image is often the base image, which rarely changes
significantly; although commercial Linux vendors publish new base images to
incorporate security fixes. Application code, however, is highly likely to
change during the software development cycle, as you iterate on features,
refactor, and fix bugs.

You can see the layers in a Docker image using `docker history`:

```bash
docker history <Image ID>
```

Which outputs something like this:

```
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
2448ae5d7584   2 minutes ago    /bin/sh -c #(nop)  ENTRYPOINT ["python3" "re…   0B
e1e77d08349a   2 minutes ago    /bin/sh -c #(nop)  USER www-data                0B
d1145be8f002   2 minutes ago    /bin/sh -c chown www-data:www-data redirect-…   2.67kB
7398fba8e399   12 minutes ago   /bin/sh -c #(nop) COPY file:5beb74d12b4c73fc…   2.67kB
264723b7458e   12 minutes ago   /bin/sh -c apt -y install python3-minimal       33.1MB
fbfb32ca228b   12 minutes ago   /bin/sh -c apt -y install nano git              102MB
7d73f8286ac4   12 minutes ago   /bin/sh -c apt -y update && apt -y upgrade      30.4MB
fb52e22af1b0   9 days ago       /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago       /bin/sh -c #(nop) ADD file:d2abf27fe2e8b0b5f…   72.8MB
```

We actually end up creating 4 layers with three `RUN` instructions and a `COPY`
command. Adding layers is typically a no-no for build times and image
sizes, but can be advantageous when iterating during local development or as we
cycle through the QA process, since we aren't reinstalling dependencies if we
don't have to.

But, we are targeting production, so let's squash some of these steps and remove
packages we simply don't need for production deployments.

```Dockerfile
FROM ubuntu:20.04
COPY redirect-livechat.py .
RUN chown www-data:www-data redirect-livechat.py && \
    apt -y update && \
    apt -y install ca-certificates python3-minimal
USER www-data
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Build a new Docker image:

```Bash
docker build -t redirect-livechat:squash-layers .
docker images
```

And run it.

```Bash
docker run --rm -p 8008:8008 -it redirect-livechat:squash-layers -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg
```

```bash
docker history <Image ID>
```

And the layers now look like this:

```
IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
2678bda0de1d   About a minute ago   /bin/sh -c #(nop)  ENTRYPOINT ["python3" "re…   0B
e1d39cda845a   About a minute ago   /bin/sh -c #(nop)  USER www-data                0B
36e7686ba479   About a minute ago   /bin/sh -c chown www-data:www-data redirect-…   70.6MB
a235ee89eda1   About a minute ago   /bin/sh -c #(nop) COPY file:5beb74d12b4c73fc…   2.67kB
fb52e22af1b0   9 days ago           /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago           /bin/sh -c #(nop) ADD file:d2abf27fe2e8b0b5f…   72.8MB
```

# Cleaning up cached files

Most package managers (`apt`, `yum`, `npm`, etc) have the ability to clean up
their own cache. If you don’t do this, you'll just be moving a bunch of unused
files into your container for no reason. It might not save a lot of space
depending on your application, but it's not a lot of effort and it's the right
thing to do.

```Dockerfile
FROM ubuntu:20.04
COPY redirect-livechat.py .
RUN chown www-data:www-data redirect-livechat.py && \
    apt -y update && \
    apt -y install ca-certificates python3-minimal && \
    apt -y autoremove && \
    apt-get -y clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
USER www-data
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Build a new Docker image:

```Bash
docker build -t redirect-livechat:cache-clean .
docker images
```

And run it.

```Bash
docker run --rm -p 8008:8008 -it redirect-livechat:cache-clean -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg
```

# Use `ENTRYPOINT` instead of `CMD`

At a surface level, there isn't a big difference between using `ENTRYPOINT` with
your app file versus running `CMD` using the shell plus your app file. However,
web- and API-type containers are often running as executables in production, and
there, proper signal handling - such as graceful shutdowns - are important.

`CMD` provides some flexibility for calling executables with flags or overriding
them by providing the executable and its parameters in the `docker ​run` command.

Many developers confuse `CMD` with `ENTRYPOINT`. However, ​`ENTRYPOINT` cannot be
overridden by `docker run`. Instead, whatever is specified in `docker run` will
be appended to `ENTRYPOINT` – this is not the case with `CMD`.

Using `CMD` in development can be useful, but that generally won't be relevant
to production instances and `ENTRYPOINT` will likely provide better signal
processing.

# Using `WORKDIR`

`WORKDIR` sets the working directory for any subsequent `ADD`, `COPY`, `RUN`,
`CMD` or `ENTRYPOINT` instructions that follow it in the `Dockerfile`

For clarity and reliability, you should always use absolute paths for your
`WORKDIR`. Also, you should use `WORKDIR` instead of proliferating instructions
like `RUN cd … && do-something`, which are hard to read, troubleshoot, and
maintain.

```Dockerfile
FROM ubuntu:20.04
WORKDIR /myapp
COPY redirect-livechat.py .
RUN chown www-data:www-data redirect-livechat.py && \
    apt -y update && \
    apt -y install ca-certificates python3-minimal && \
    apt -y autoremove && \
    apt-get -y clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
USER www-data
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Build a new Docker image:

```Bash
docker build -t redirect-livechat:workdir .
docker images
```

And run it.

```Bash
docker run --rm -p 8008:8008 -it redirect-livechat:workdir -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg
```

# How has the Dockerfile changed?

Let looks at the diff

```bash
git diff
```

ANd here is the diff:

```diff
diff --git a/Dockerfile b/Dockerfile
index 9824527..b3b023e 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -1,6 +1,11 @@
-FROM ubuntu:latest
-RUN apt -y update && apt -y upgrade
-RUN apt -y install nano git
-RUN apt -y install python3-minimal
+FROM ubuntu:20.04
+WORKDIR /myapp
 COPY redirect-livechat.py .
+RUN chown www-data:www-data redirect-livechat.py && \
+    apt -y update && \
+    apt -y install ca-certificates python3-minimal && \
+    apt -y autoremove && \
+    apt-get -y clean autoclean && \
+    rm -rf /var/lib/{apt,dpkg,cache,log}/
+USER www-data
 ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

# Resources
- [Docker and DevOps - Bret Fisher](https://www.youtube.com/BretFisherDockerandDevOps)
- [Docker for Web Developers - Coding with Dan]([https://www.pluralsight.com/courses/docker-web-development)
- [How to Get Started with Docker - Docker's Peter McKee](https://docs.docker.com/get-started/)
- [Docker for Developers - Andy Dennis & Richard Bullington McGuire](https://www.packtpub.com/product/docker-for-developers/9781789536058)
