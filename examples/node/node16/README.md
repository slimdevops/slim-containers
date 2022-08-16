# Container of the Week: Node JS Hello World

- [Container of the Week: Node JS Hello World](#container-of-the-week-node-js-hello-world)
  - [Introduction :wave:](#introduction-wave)
    - [TL;DR:](#tldr)
    - [Results Summary :chart_with_upwards_trend:](#results-summary-chart_with_upwards_trend)
  - [About the Container :thinking:](#about-the-container-thinking)
  - [Our Sample App](#our-sample-app)
    - [Dockerfile](#dockerfile)
  - [Slimming The Image :mechanical_arm:](#slimming-the-image-mechanical_arm)
  - [Results :raised_hands:](#results-raised_hands)
    - [Success Criteria](#success-criteria)
    - [Image Size](#image-size)
    - [Security Scan](#security-scan)

---
## Introduction :wave:
Today, we are slimming a straightforward Node.js hello-world app using the latest official image provided on Dockerhub. 

### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 911 MB | 86 MB | 10.6X |
| Total vulernabilities| 2224 | 2 | 1112X | 
| Critical vulernabilities| 57 | 0 | inf | 
| Time to Push | 61s | 9s | 6.8X | 
| Time to Scan | 33s | 4s | 8.3X | 

## About the Container :thinking:
- **Base Image:** Node (Docker Official)
- **Key Frameworks and Libraries:** [Node](https://nodejs.org/en/) / [Javascript](https://www.javascript.com/) 
- **Base Image Size:** 911 MB
- ['Slim.AI Profile'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fnode%3A)
- **Common Use Cases:** Event-driven servers, Complex SPAs, Real-time websites

## Our Sample App

For this app, we'll use Express - a lightweight framework for building flexible web-apps on the node Javascript runtime environment. We'll also declare a port that our app will use.

```javascript
const express = require('express')
const app = express()
const port = 3000
```
From there, with just a couple function calls from the app object we'll have everything we need to get our app running.

```javascript
app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
```
The app.get call sends the hello world message to our base url route, and the app.listen bind and listen the port we passed along.



### Dockerfile
To dockerize our application, we can use a basic dockerfile.

Original Dockerfile: 
```
FROM node:14
WORKDIR /usr/src/app
COPY package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]
```
This Dockerfile will create the app with all of the intended functionality, however it has some characteristics that we try to avoid on production containers. Particularly, we built the app with access to the container root user, which can introduce vulnerabilities. Fortunately, the node base image defines a user "node" which is better suited to be shipped to proudction for users. Also, instead of npm install, we can run a "clean install" and cache clean in the same layer. The clean install will ensure reproducibility and the cache clean will eliminate the npm cache (no need for an npm cache when docker has made one for us!). To learn more about  good practices for production containers, you can read about it on the Slim.ai [blog](https://www.slim.ai/blog/five-things-you-should-never-ship-to-production-in-a-container.html). 

Production Dockerfile: 
```
FROM node:14.16.1
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci && npm cache clean --force
COPY app.js ./
USER node
EXPOSE 3000
CMD ["node","app.js"]
```

From here, we can create the image using docker build and use . to indicate the Dockerfile is in our current directory.

```bash
$ docker build -t node-hello-world .
```

```bash
REPOSITORY                                    TAG             IMAGE ID       CREATED              SIZE
node-hello-world                              latest          e06647f4926e   2 hours ago          911MB
```

Now, we can run our app in a container by using the docker run command. Because this app is using our 3000 port, we should match the container port to our host machine port by using the -p tag.


```bash
$ docker run -p 3000:3000 node-hello-world nhwc
```

We can visit 'localhost:3000' to see your hello world message and verify everything worked correctly. After we verify, docker kill nhwc will stop the container and free up the port.

## Slimming The Image :mechanical_arm:
If you think 911MB seems a bit large for an app as simple as this, you would be absolutely correct. We can do much better than this by utilizing Dockerslim CLI to remove unnecessary files from our container. If you don't have Dockerslim installed, you can go to our github for [installation instructions](https://github.com/docker-slim/docker-slim). The Dockerslim build command will automatically run and analyze our container before creating a new image that is (hopefully) smaller and more secure!

```bash
docker-slim build --target node-hello-world
```

## Results :raised_hands:
```bash
REPOSITORY                                    TAG             IMAGE ID       CREATED              SIZE
node-hello-world.slim                         latest          e55768ea673a   5 minutes ago        86.8MB
node-hello-world                              latest          e06647f4926e   2 hours ago          911MB
```
### Success Criteria
### Does it work?
Before we celebrate a slim image, we should be sure to run the app and verify it functions as it did before. Often times a second run at Dockerslim is needed with some tweaks to the configuration after consulting the docs. After running the new container with the same command we used for the original, we find that the image does in fact work.
### Is it slimmer?
Yes! The image is less than 10% the size of the original, a significant improvement that allows for faster scans, builds, and pushes.
### Is it more secure?
Yes again! reducing the attack surface of the image was able to eliminate all but 2 of the total vulnerabilities, and took out all of the critical issues.
