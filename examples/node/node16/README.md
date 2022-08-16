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

### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 911 MB | 86 MB | 10.6 X |
| Total vulernabilities| 2224 | 2 | 1112x | 
| Critical vulernabilities| 57 | 0 | inf | 
| Time to Push | 61s | 9s | 6.8 X | 
| Time to Scan | 33s | 4s | 8.3x X | 

## About the Container :thinking:
- **Base Image:** Node (Docker Official)
- **Key Frameworks and Libraries:** [R](https://www.r-project.org/) / [#Rstats])https://twitter.com/hashtag/rstats), [Shiny]/(https://shiny.rstudio.com/)  
- **Base Image Size:** 885 MB
- ['Slim.AI Profile'](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fpython%3Alatest)
- **Common Use Cases:** Data visualization, statistics, statistical programming 

## Our Sample App 




### Dockerfile
Original Dockerfile: 
```
FROM node:14
WORKDIR /usr/src/app
COPY package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]
```

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
