# Container of the Week: NuxtJS

- [Container of the Week: NuxtJS]
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
Here at Slim.AI, we use VueJS and its web-development framework NuxtJS in most of our developer-facing frontend applications. VueJS is simple, scalable, and an easy transition for most developers with a bit of Javascript background. NuxtJS takes the pain out of rigging up a web application, providing an easy starting point for Vue apps. It also comes with a lot of baked-in magic in the way of [Nuxt Modules](https://modules.nuxtjs.org/), making things like rendering Markdown or adding a grid-system super simple. 

Nuxt and Vue are build for modern frameworks, incorporating a lot of nice tricks for seamless interactions. These benefits, however, can make slimming a containerized Nuxt application a bit nuanced, as we've learned slimming our own front-end apps.  

Let's take a look at the best way to do it. 

### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 1.45 GB | 309 MB | 4.7 X |
| Total vulernabilities| TK | TK | TK | 
| Critical vulernabilities| TK | TK | TK | 
| Time to Push | TKmTKs | TKmTKs | TK X | 
| Time to Scan | TKmTKs | TKmTKs | TK X | 



## About the Container :thinking:
- **Base Image:** Node LTS
For this example, we need to use an `LTS` version of the Node base image. We'll use the Docker Official Node image and start with the basic `LTS` ("long-term support") image from the Docker Node community. 

- **Key Frameworks and Libraries:** 
-- [VueJS](https://www.vuejs.org) - Vue is an increasingly popular, modern Javascript framework with a focus on organization, compentization, performance, and versatility.  
-- [NuxtJS](https://nuxtjs.org) - Nuxt is a framework meant to be what the `NextJS` framework is for React: A lightweight but powerful starting point for web apps. 
-- [Vuetify](https://vuetifyjs.com) - Vuetify is a Bootstrap-like front-end framework built with native Vue & Nuxt support. It provides a standard grid system, components like carousels and form fields, and a Material Design UI. 

- **Base Image Size:** 851 MB
- ['Slim.AI Profile'](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fpython%3Alatest)
- **Common Use Cases:** Data visualization, statistics, statistical programming 

## Our Sample App 
This app was built as part of our **Containers 101** Series streamed live on Thursday on [twitch.tv/slimdevops](https://twitch.tv/slimdevops) (join us next time!). As part of that Series, we were building a photo carousel app that allowed users to upload images, categorize them and 




### Dockerfile

## Slimming The Image :mechanical_arm:

## Results :raised_hands:

### Success Criteria
### Image Size
### Security Scan 
