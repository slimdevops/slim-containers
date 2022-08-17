# Container of the Week: CircleCI: cimg/node

- [Container of the Week: CircleCI: cimg/node](#container-of-the-week-circleci-cimg/node)
  - [Introduction :wave:](#introduction-wave)
    - [TL;DR:](#tldr)
    - [Results Summary :chart_with_upwards_trend:](#results-summary-chart_with_upwards_trend)
  - [About the Container :thinking:](#about-the-container-thinking)
  - [Our Sample App](#our-sample-app)
    - [Dockerfile](#dockerfile)
    - [Testing Original Container](#testing-original-container)
  - [Slimming The Image :mechanical_arm:](#slimming-the-image-mechanical_arm)
      - [Using an include file](#using-an-include-file)
  - [Results :raised_hands:](#results-raised_hands)
    - [Success Criteria](#success-criteria)
    - [Test Run](#test-run)
    - [Image Size](#image-size)
    - [Security Scan](#security-scan)

---
## Introduction :wave:



### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 1.61 GB | 102 MB | 15.9X |
| Total vulernabilities| 271 | 0 | inf | 
| Critical vulernabilities| 14 | 0 | inf | 
| Time to Push | 15s | 8s | 1.9X | 
| Time to Scan | 103 | 24s | 4.3X | 
| Time to Build | 204s | 89s | 2.3X |

## About the Container :thinking:
- **Base Image:** cimg/node (Maintained by CircleCI)
- **Key Frameworks and Libraries:** [Node](https://nodejs.org/en/) / [Javascript](https://www.javascript.com/) 
- **Base Image Size:** 1.28 GB
- **Common Use Cases:** Event-driven servers, Complex SPAs, Real-time websites

## Our Sample App 
Today we're going to be slimming a robust real-world web-app built off of the cimg/node image managed by CircleCI. The code for the app is provided by [Contentful](https://github.com/contentful/the-example-app.nodejs) - check out the linked repository if you're interested in uses for the app and tons more educational informatoin.

### Node Dockerfile
```Dockerfile
FROM node:9

WORKDIR /app

RUN npm install -g contentful-cli

COPY package.json .
RUN npm install

COPY . .

USER node
EXPOSE 3000

CMD ["npm", "run", "start:dev"]
```

The source code for this app allows a build options using the node:9 image using this provided Dockerfile. However, we're going to build the app using the latest cimg/node base image for its additional tooling. On first glance, it seems as easy as changing the argument for "From" to cimg/node:18.7.0, but this neglects a few important details. For one, the default user for an offical Node image is the root user. This allows for the Docker to install the necessary software before switching the user to node. In our cimg/node image, the default user does not have this permission level. We'll need to manually set the user to root and then after the installs clear, set the user to something more secure (the root user should never be shipped to a production container). The node user isn't created in the cimg/node base image, however a quick look at the meta-data of the image using the docker inspect command tells us that they've provided a similar user "circleci" which we can switch to. Finally, we can build from the below Dockerfile.

```Dockerfile
FROM cimg/node:18.7.0

USER root

WORKDIR /app

RUN npm install -g contentful-cli

COPY package.json .
RUN npm install

COPY . .

USER circleci

EXPOSE 3000

CMD ["npm", "run", "start:dev"]

```

With this file, we can build using the below command.

```bash
docker build -t contentful .
```


## Slimming The Image :mechanical_arm:

Thanks to the recent public launch of some of our newest features at Slim.ai, anyone can optimize their images with a free account on our [slim platform](https://portal.slim.dev/home). Simply upload your image to your preferred container registry, connect the registry to the slim platform using a personal access token, locate your image and click optimize. For this app, all we need to select in the configuration menu is "server application" and exposed ports 3000:tcp and the process will complete auotmatically.

## Results :raised_hands:
![Results](/images/contentful-report.png)

Our optimization was successful, and our image has been made nearly 16x smaller! All thats left to do is pull the image down from whatever registry you outputted to, and run!

```bash
docker run -p 3000:3000 -d contentful
```

By visiting localhost:3000 we can see that our application is fully intact and working just as before!

