# Containers 101

# Introduction
Here by popular request! This tutorial is meant for viewers of the [SlimDevOps Twitch Stream](https://www.twitch.tv/slimdevops). Several of our community members expressed an interest in this "Square One" overview of all things containers, along with a hands-on "bring your own app" live coding workshop.

This tutorial seeks to help developers understand container technology, know the major tools required to create and manage containers, and get them ready to ship to production.

In this tutorial, we will cover:
- What is a container and why would I use one?
- Basic Docker commands
- Creating a container for your application
- Making your Dockerfile ready for production
- Pushing the image to Docker Hub

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

# What is a container?
A container is a unit of software that packages libraries and dependencies, emulating an independent server but still running on your local host. The goal of a container is to create a reproducible, immutable, and ephemeral environment that can run an application reliably on any hardware.

| A container is like a... | Kind of | Not quite |
| ---------- | --------- | ------- |
| Virtual Machine | It is a self-contained environment | It doesn't have a Guest OS layer like a VM |
| Development Environment | Libraries and dependencies are unique to the container | It is designed to be shipped along with the app |
| Independent OS | The container has its own filesystem | It still runs on the local host and can access the local OS |


## When we say 'container' do we mean 'Docker'?
Docker is the most popular container daemon, management software, and container repository (Docker Hub) among developers today. Docker's ease of use and great tooling paved the way for the wide adoption of containers and it remains the way most developers interact with containers in the modern eco-system.

However, Docker isn't the ONLY option for working with containers. Projects such as the CNCF's [ContainerD](https://containerd.io/) and the [Open Container Initiative](https://opencontainers.org/) are starting to gain wider adoption, there has been a large proliferation in [container registry options](https://www.slim.ai/blog/understanding-container-registries-public-vs.private-container-images.html) in recent years.


# Why use containers?
The primary benefits of using containers is to reduce the overhead and unpredictability that comes from developing software at scale, that is to say solving the classic: "It worked on my machine" conundrum. Containers allow you to explicitly declare specific versions of libraries, operating systems, and other depedencies to ensure your app works the way it is supposed to no matter where it is hosted.

![That's how docker was born meme](../images/docker_born_meme.jpg)

## What are some of the drawbacks to using containers?
While the adoption of containers is growing steadily in organizations -- alongside related and equally as stratospheric Kubernetes and microservice architectures -- it is still relatively early days for containers and there are several challenges developers face in adopting containers. Such as:

- **Learning curve / specialization:**
- **Knowledge of best practices:**
- **Staying current with updates and security patches:** Managing containers across even a modest size team can turn into a job itself. Many large organizations now have dedicated DevX teams who are at least partially responsible for curating and maintaining container images. Updating images can be either labor intensive (when done manually) or opaque (when done automatically), leading to break-fix cycles that frustrate devs.

# Basic Terminology
- **Docker daemon**: The Docker program running on the local host that makes Docker possible
- **Container Image**: This is a set of files and instructions that allow you to `docker run` a container, creating a single instance of a Container instance
- **Container**: This is a single unit created from a Container image. It is ephemeral and will be completely destroyed when removed

## Common Docker Commands
| command | use | example | flags |
| ------- | --- | ------- | ---- |
| docker pull | pull public image to local machine (from Docker Hub, unless otherwise specified) | docker pull ubuntu:latest | |
| docker build | build image from the Dockerfile localed in current dir | `docker build --name me/myimage .`| |
| docker images | get list of local images | `docker images \| grep ubuntu` | |
| docker run | create single container from container image | `docker run --name mycontainer -it ubuntu:latest` /bin/bash | -d (run as daemon) -it (interactive mode) -p (specify port) --name (name container, otherwise randomly generated) |
| docker ps | list current running images | `docker ps` | |
| docker rm | remove container | `docker rm mycontainer` | |
| docker rmi | remove container image (see also `prune`) | `docker rmi myimage` | -f (force) |

# Your application

Martin has a simple Python application we can use as an example:

  * https://github.com/wimpysworld/redirect-livechat

Let's limber up.

# Tutorial: The wrong way!

**This is *not* the way!**

![mandolarian not the way](https://c.tenor.com/2BKNUekYGAEAAAAd/baby-yoda.gif)


## 1. The base image

=======

Pull the latest Ubuntu image.

`docker pull ubuntu:latest`

## 2. Exploring a base image

Shell into the image to take a look around.

`docker run -it ubuntu:latest /bin/bash`

You can play around. Note: Anything you do in this shell is **adding information
to a new container** based on `ubuntu:latest`. NO changes are made to
`ubuntu:latest` and NO changes are made to your local system.

Look at the shell prompt, for the new container Id.

```
root@48738792332d:/#
        ^
        +----- The container id
```

What is in the Ubuntu container:

```
apt list
apt list | grep linux
```

Let's update our container.

`apt update && apt -y upgrade`

Let's install the best editor and `git`.

`apt -y install nano git`

## 2. Adding our application

Here a simple pure Python app that I built.

`git clone https://github.com/wimpysworld/redirect-livechat.git`

Let's run it.

`cd redirect-livechat`
`./redirect-livechat.py UCQvWX73GQygcwXOTSf_VDVg`

Erk, no `python3`. Let's install Python 3.

`apt -y install python3-minimal`

Does it work now?

`./redirect-livechat.py UCQvWX73GQygcwXOTSf_VDVg`

Connect to http://localhost:8008/ from your web browser.

We need to bind ports.

`exit`

## 3. Make a container from our changes

Find out container instance.

`docker ps -a`

Let's save what we done.

`docker commit <CONTAINER_ID> redirect-livechat:the-wrong-way`
`docker images`

Let's run the container and bind the port. We'll also run the app directly,
rather than shelling into the container.

`docker run -p 8008:8008 -it redirect-livechat:the-wrong-way /redirect-livechat/redirect-livechat.py -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg`

Connect to http://localhost:8008/ from your web browser.

Success! You have made a container in absolutely the wrong way!

# Tutorial: The Ubuntu way

`Dockerfile` is used to automate to creation of a Docker container. Let's
recreate the same container image using a `Dockerfile`.

## 1. Creating a Dockerfile

```
FROM ubuntu:latest
RUN apt -y update && apt -y upgrade
RUN apt -y install nano git
RUN apt -y install python3-minimal
COPY redirect-livechat.py .
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

But, just like Blue Peter, *"here's one we prepared earlier"*.

`git checkout the-ubuntu-way`

## 2. Build your image

```
docker build -t redirect-livechat:the-ubuntu-way .
docker images
```

### And test it

`docker run -p 8008:8008 -it redirect-livechat:the-ubuntu-way -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg`

# Tutorial: The Python way

Let use a ready-made Python enable container, which is based on Debian

  * https://hub.docker.com/_/python

## 1. Creating a Dockerfile
You'll need to create a `Dockerfile` text file using your favorite text editor -- in my case, `nano`. 

```
nano Dockerfile
```

The text of the Dockerfile should be this. 

```
FROM python:3-slim
RUN apt -y update && apt -y upgrade
RUN apt -y install nano git
COPY redirect-livechat.py .
ENTRYPOINT [ "python3", "redirect-livechat.py" ]
```

Again, *"here's one we prepared earlier"*.

`git checkout the-python-way`

## 2. Build your image

```
docker build -t redirect-livechat:the-python-way .
docker images
```

### And test it

`docker run -p 8008:8008 -it redirect-livechat:the-python-way -a 0.0.0.0 UCQvWX73GQygcwXOTSf_VDVg`

# Container Best Practices - Dockerfile improvements

- Don't use `latest`
- Install security updates
- Don't run as root
- Optimize build dependencies
- Pick the best `ENTRYPOINT` or `CMD`

We published an article discussing the above on dev.to.

  * [Creating Production-Ready Containers - The Basics](https://dev.to/wimpress/creating-production-ready-containers-the-basics-3k6f)

# Tutorial: Publishing your Docker container

## 1. Push to Docker Hub

```
docker login -u YOUR_DOCKERHUB_NAME
docker tag redirect-livechat:the-python-way YOUR_DOCKERHUB_NAME/redirect-livechat:the-python-way
docker push YOUR_DOCKERHUB_NAME/redirect-livechat:the-python-way
```

# Resources
- [Docker and DevOps - Bret Fisher](https://www.youtube.com/BretFisherDockerandDevOps)
- [Docker for Web Developers - Coding with Dan]([https://www.pluralsight.com/courses/docker-web-development)
- [How to Get Started with Docker - Docker's Peter McKee](https://docs.docker.com/get-started/)
- [Docker for Developers - Andy Dennis & Richard Bullington McGuire](https://www.packtpub.com/product/docker-for-developers/9781789536058)
