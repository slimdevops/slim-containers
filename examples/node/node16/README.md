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
| Size | 911 MB | 86 MB | 10.6 X |
| Total vulernabilities| 2224 | 2 | 1112 x | 
| Critical vulernabilities| 57 | 0 | inf | 
| Time to Push | 61s | 9s | 6.8 X | 
| Time to Scan | 33s | 4s | 8.3 X | 

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


```bash
$ docker build -t cotw-node .
```

```
REPOSITORY                                    TAG             IMAGE ID       CREATED              SIZE
cotw-node                                     latest          ded63a303213   About a minute ago   893MB
```
## Slimming The Image :mechanical_arm:

## Results :raised_hands:

### Success Criteria
### Image Size
### Security Scan 
