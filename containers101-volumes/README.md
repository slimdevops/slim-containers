# Containers 101 - Part 3: Volumes

# Introduction
Now that we have a good understanding of what a container is, how to create a Dockerfile, and some initial best practices, now let's start working with data. This tutorial covers the basics of mounting volumes to your containers. 

If you remember, containers are *ephemeral*, which is a fancy way of sayin "when they're gone, they're gone." This makes containers great for scaling up and down apps, but pretty terrible for storing pictures of your dog. Thankfully, we can connect ("mount") space on our local host to the container, creating a place outside of the container in which to store things. This could be as simple as a folder to store images or as complex as the datafile used by a database. 

In this tutorial, we'll do both of those things, creating a containerized "Photo Server" app in ~~NodeJS and Vue~~ Python. 

# The App
The most popular gift in my family right now is the [Aura Frame](https://auraframes.com). My parents love getting photos sent to their device, and Wimpy and I thought it would be fun to create a makeshift, home-server version of a photo app to show off how mounting volumes works in containers. 

For our tutorial, the app isn't super important. We wanted to do just a few basic operations:

1) Present all of the images from a certain folder in a slideshow
2) Let users upload new images
3) Provide some categorization for the images that we aren't using right now but that our PM insists will be important to future growth :wink: 

You don't need to actually build the app. I've included a link to the app code and provided in the repo in case you're curious (or want to help with the CSS! PRs welcome). It is useful to grab or update this repository so you can follow along with the files. 

``` git clone slimdevops/slim-containers ``` 

Or just `git pull` if you already have the repo. 

Since this app is **containerized**, all you REALLY need to do to follow the demo is pull the container from my public Docker Hub repo: 

`$ docker pull slimpsv/pyphotoapp:start` 

# Running the Docker Container 
First, let's spin up the container and test it. 

```$ docker run -dp 5000:5000 slimpsv/pyphotoapp:start ```

Here, we run the container, mapping port `5000` in the container to port `5000` on our localhost. 

We don't give the container a `--name` but feel free. Running `docker ps` will show us the running container. 

Let's visit `localhost:5000` in our web browser and we'll see our app running. Beautiful, ain't it? 

We have a slideshow, an uploader, and some radio buttons for our three photo categories: `Swag`, `Cookies`, and `Tea`. 

Let's try uploading a photo. We do so and see that the image appears in the slideshow. 

We can then shell into the container and see that image is there in the `/app/static/images` folder, just like we expected.

```
$ docker exec -it <conatiner name or ID> /bin/bash 
```

Note, we're using a new Docker command here -- `exec` -- along with the familiar `-it` flags. Exec lets us run a command on a running container. Hello, we're in the conatiner! We can `cd` over to our image folder and `ls -la` to see the images. 

```
-rw-r--r-- 1 root root 513611 Sep 15 22:26 a_codi_socks.png
-rw-r--r-- 1 root root  90992 Sep 15 22:24 codi-tshirts.png
-rw-r--r-- 1 root root 365872 Sep 15 22:24 codi_stickers.png
### our newly uploaded files ###
```

Remember all those best practices from last week, like not running Root and all? Yeah, we didn't do that. More optimizations to come! 

# But Wait... 
So now let's stop the container and remove it. 

```
docker stop <containerid> 
docker kill <containerid>
```

Where did our images go? 

They're gone, baby, gone. If we had restarted the container, we'd still have access to them. But since we removed that container completely, we can't. If we do `docker run` again, __we are creating a NEW container from the image slimpsv/pyphotoapp:start`__. 

We can do that and we'll see that the images are gone. 

# Volumes
This is where volumes come in. Docker makes it easy to mount a local directory to your container, allowing you to effectively mirror a local directory in your container and vice versa. 

![](https://docs.docker.com/storage/images/types-of-mounts-volume.png) (courtesy Docker.com)

We won't get into the nuances of `bind-mounts` vs `tmpfs` vs `volumes`. For now, we can just think of these as linking our container to a local dir. 

The best part about this, is we can do it without changing our container at all. We just merely need to change the run command, adding a `-v` flag to it. 

So first, let's stop our current container if we have one running (`docker ps` to check). 

Then let's spin up a new container with this command: 

```
$ docker run -dp 5000:5000 -v <your_local_path>/containers101-volumes/pyphotoapp/static/images:/app/static/images slimpsv/pyphotoapp:start 
```

Replace `<your_local_path>` with, well, your local path. :hmm: 

The same test should run. We can go to `localhost:5000`. Before you do anything, be sure you can see the `static/images` folder that's created in the git repo. 

NOW when you upload your file to the container, you should see the image you just uploaded both show up in the slideshow AND appear in your local `static/images` directory.

![magic](https://media.giphy.com/media/lzL6avFZQ8PJEjdFgS/giphy.gif)

If we spin up another container on another port, say `5005`, we can see that they can actually map to the same volume. 

```
$ docker run \
  -dp 5005:5000 \
  -v <your_local_path>/containers101-volumes/pyphotoapp/static/images:/app/static/images slimpsv/pyphotoapp:start 
```

# Let's do more! 
So this works pretty well for files and connecting them locally. You can see the usefulness of tying a container to local folder for development or to something like an S3 bucket for something larger. 

But what about our categories? Well, volumes are great for that as well. 

If you've seen the `image.db` file in our exploration, that's just what it says. In the app, we used `sqlite3` to create a lightweight database to store our category image. 

But like our images, that database file is also now getting nuked each time we start and stop the container. 

It's easy enough for us to add another volume, this time for the db file. 

```
$ docker run -dp 5000:5000 -v $SLIM_JAM_PATH/pyphotoapp/static/images:/app/static/images -v $SLIM_JAM_PATH/pyphotoapp/image.db:/app/image.db slimpsv/pyphotoapp:start 
```

# Volumes Created Via Docker
We've been creating volumes (technically, 'bind mounts') to local folders because it's easy to see and understand. 

You can also use Docker to create a shared volume, using the `docker volume create` command. It will work the same way as a local file or folder, but is easier to handle in the CLI. 

These volumes, and any data inside of them, can easily be seen in Docker Desktop, and like binding a local folder, be shared between containers. 

We'll explore shared volumes more in our next Containers 101 Tutorial, when we split this photo sharing app into 3 separate microservices (front-end, back-end, database), and use Networking and Docker Compose to stitch it all together. 

Thanks for watching! 


# Notes
I built this on a Mac M1. While support for M1s has gotten better, you still run into architecture issues at times. I built the image with Docker's BuildX function, which hopefully means broader support. 

If you run into issues running the container, you can try `docker build .` on the `Dockerfile` provided and it should work. 

BuildX run command:
`docker buildx build --platform linux/amd64,linux/arm64 -t slimpsv/pyphotoapp:start --push .`
