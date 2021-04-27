--
title: Container of the Week: Python-Flask-Nginx

--

- Intro
- About the container
- Our Sample App 
- Building the Dockerfile
- Slimming Process
-- Inspect the container (using XRay or Slim Portal) 
-- Run Profile see simulate the build process
-- Run Build with key flags 
- Results
- Resources

# Introduction to the Python-Flask Container

Today, we are going to be slimming a simple app housed in a container we built from the base Python 3.X image and leverageing Flask, one of the most common web microframeworks available. We build a basic sample app that merely takes a request url and returns a basic JSON response. This is a common pattern for building RESTful APIs and putting them in a container for repeatability and scalability. 

Like REST APIs, Flask is starting to lose some favor to more recent API approaches leveraging GraphQL, but make no mistake, REST and Flask aren't going anywhere so long as JSON data remains a valuable interchange. Flask is also so quick and easy to set up, it makes for a great prototyping tool or even can be used for lightweight web applications. While other frameworks -- notably Django (for Python enthusiasts) or Node.JS (for Javascripters) -- are considered more robust for full-scale development. (Flask proponents, like myself, will hotly debate this!) 

In our research, a basic Flask application can weight in at close to 1 GB container if just "taken off the shelf". Given the basic nature of most Flask apps, this might not be a big deal if you have ordered your Docker build well, but is still unnecessarily large. In our trial, we were able to slim the image to a mere 33 MB :eyes:. Let's look at what we did. 

# About the Container: 
## Metadata
> **Base Image:** Python 3.8 Official
> **Key Frameworks and Libraries:** Flask 
> **Base Image Size:** 885 MB
> ['Slim.AI Profile'](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fpython%3Alatest)

Common Use Cases:
- RESTful APIs
- Lightweight web apps
- Web prototypes

# Our Sample App 
We want a basic Dockerized "request and response" API that servers a simple JSON message when it is working correctly. 

## Application
Project structure

```
Dockerfile
README.md
/app
|- app.py
|- requirements.txt
```

> When building the app, it's useful to have a **virtual environment** set up in your local development space, and have that folder included in your `.gitignore` file if you are putting planning to use the project via version control. These elements are outside the scope of this article, but join us on Discord if you are struggling to get this running locally. 

We build a very simple (and I mean, really simple) Flask API that merely returns a JSON message if successful. Otherwise, it fails horribly. 

```
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def index(): 
    return jsonify({'msg': 'Success!'}) 


if __name__ == "__main__": 
    app.run(host='0.0.0.0', port=1300, debug=True) 
    
```

We cheat a little and use Flask's built-in `jsonify` function to return clean JSON, and we turn on the `DEBUG` flag so that Flask will be noisy as it runs and automatically restart when new changes appear. This is more useful for local development, but 

**Specific to Docker**, we want to make sure that `host` is set to `0.0.0.0`. **This is a common failure mode in Dockerizing Python-Flask applications.** We'll get more into **IP addresses** and **port forwarding** in a later article, but basically you can think of this as use telling Flask to talk to the Docker container's protocols, rather than the traditional `127.0.0.1` that you see in local Flask development. Further, we use port `1300` merely for example purposes. It will help show how Docker handles HTTP ports and also how DockerSlim probes and reports on open ports. 

You can run the application locally with `python app.py` and visiting `0.0.0.0:1300` in your browser. It should return the response `msg: "Success!"` in JSON format. 

## Requirements.txt
The Python package manager is going to want a `requirements.txt` file to know which libraries to install for our app. The easy thing to do is to run `pip freeze > requirements.txt` in your `/app` directory. However, this is going to dump any and all libraries from your virtual environment into the image. DockerSlim will do its best to eliminate unneeded dependencies, but we can also just explicitly state which packages we want and let pip figure out the dependencies on build. 

```
Flask
```

## Dockerfile
Now we Dockerize the app with a few basic commands. 

We're going to use the base Python image in this application. With 1B+ downloads from Docker Hub, it is one of the world's most popular starting points for Docker development, and readily available on any Container Registry (Docker Hub, Amazon ECR, Quay, GCR, etc). 

Before using the image, we can inspect it in the [Slim Web Portal](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fpython%3Alatest) or by using the DockerSlim XRay command. Doing this shows us a few key things. 

1. PIP installed 
``` PYTHON_PIP_VERSION	=	21.0.1 ```
We can see that `pip`, the Python package manager, is included in the `latest` version. This will be the case with basically any image worth its salt, but it's also good practice to know what package managers and other tools are available in your container before starting. 

2. Versions! 
Being Marsha Brady-level popular among development languages, naturally there's about a million versions of this container under the flag of the Official Docker image. Some notable names include Alpine and Buster, but we'll use the plain vanilla `latest` for our exercise. 

If you want to have the image locally, you can run `docker pull python` to have a local version, though we don't need it for this exercise. 

Our basic Dockerfile looks like this: 

```
FROM python:latest

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 1300

ENTRYPOINT ["python","/app/app.py"]

```

Our `FROM` grabs the latest Python image and uses it as a base image. We are making a trade-off decision here using `latest` versus explicitly stating a version. Latest ensures any new build will use the most up-to-date image provided by the maintainer, but could lead to compatability issues in future builds if dependencies change. 

We then copy our current working directory into the conatiner's `/app` directory and run our `pip install` to install Flask and its dependencies. 

We expose the `1300` port (see previous note) for the purpose of this example. And finally, we use the ENTRYPOINT command run the equivalent of `python /app/app.py`. A lot of people new to Docker struggle with using [ENTRYPOINT vs. CMD](https://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile). We use ENTRYPOINT here since we won't need to run commands from the container or shell into it. 

We can build the image from our root project directory, using the `-t` flag to "tag" the image as our project name and the `.` arugment to let Docker know that the Dockerfile is in the current working directory. 

```
docker run -t cotw-python-flask .
```

Our output looks like...

```
Step 1/6 : FROM python:latest
 ---> 49e3c70d884f
Step 2/6 : COPY ./app /app
 ---> 4b8426a23832
Step 3/6 : RUN pip install -r /app/requirements.txt
 ---> Running in d63d4b7bb2d3
Collecting Flask
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting click>=5.1
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting itsdangerous>=0.24
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Werkzeug>=0.15
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Collecting Jinja2>=2.10.1
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp39-cp39-manylinux2010_x86_64.whl (32 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, Flask
Successfully installed Flask-1.1.2 Jinja2-2.11.3 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 itsdangerous-1.1.0
WARNING: You are using pip version 21.0.1; however, version 21.1 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
Removing intermediate container d63d4b7bb2d3
 ---> c7792be79051
Step 4/6 : EXPOSE 1300
 ---> Running in 54b67ef45e31
Removing intermediate container 54b67ef45e31
 ---> 7f8993b25f24
Step 5/6 : ENTRYPOINT ["python","/app/app.py"]
 ---> Running in 0f8beac4bb0c
Removing intermediate container 0f8beac4bb0c
 ---> 059d858fdfee
Step 6/6 : LABEL cotw-python-flask=
 ---> Running in 4f57c1da494e
Removing intermediate container 4f57c1da494e
 ---> 75a3a2837473
Successfully built 75a3a2837473
Successfully tagged cotw-python-flask:latest

```

Fun fact: The `pip` error is referring to the version of pip installed in the container. 

I can now `docker images` to see the built container: 

```
REPOSITORY                TAG       IMAGE ID       CREATED              SIZE
cotw-python-flask         latest    75a3a2837473   About a minute ago   895MB
```

Note the image size is just slightly bigger than the base container, since we added Flask and it's dependencies. 

And I can use `docker run -dp 1300:1300 --name cotwcontainer cotw-python-flask` to spin up a **container** running the newly built image and run `docker ps` to see it. 

```
CONTAINER ID   IMAGE               COMMAND                CREATED          STATUS          PORTS                                       NAMES
4b3ddb7393d7   cotw-python-flask   "python /app/app.py"   19 seconds ago   Up 18 seconds   0.0.0.0:1300->1300/tcp, :::1300->1300/tcp   cotwcontainer

```

As expected, visiting `http://0.0.0.0:1300/` returns the success message as it did locally, only now it's coming from the running container, not a local application! 

# Slimming The Image 









