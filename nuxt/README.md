# Containers 101 - Part 5: Building a Frontend for Our Multicontainer Web App

# Introduction
Ok, so let's be honest about this little Python-Flask photo app that we've built. As [@FrenchguyCH](twitch.tv/frenchguych) honestly assessed in [Twitch Stream 028](https://www.twitch.tv/videos/1255080620): 

> "app" might be a bit overselling it, no disrespect :wink: 

And he couldn't be more right. Python's Flask library is great for APIs, and it's templating engine (Jinja2) can be powerful for both prototypes and complex UIs alike, if you know how to use it and don't mind creating your own components.   

But our app has a few major challenges: 

- **It's ugly:** Flask's templating engine is powerful in the hands of accomplished front-end folks, but lacks the "out of the box" polish of a specialized front-end framework. We haven't taken the time to write custom CSS and Javascript to make it pretty, responsive, and easy to use.  
-  **FE Devs would expect JS:** If we're hiring front-end developers to help build this application, they will be more familiar and more excited to work on a modern framework like React, Vue, or Flutter. Those frameworks tend to have better support for components, design systems, and accessibility. 
- **Relies on random libraries found on the Internet:** This approach is quick for prototyping but can be risky at scale.  
- **Possible memory leak:** It's prone to crashing certain browsers and we don't know why. 

So what are we going to do? Well, in our last session we created a [Docker Compose](https://github.com/slimdevops/slim-containers/tree/master/containers101-docker-compose) file that is beginning to split the app up into multiple services. 

![Multiservice architecture diagram of app](https://github.com/slimdevops/slim-containers/raw/master/containers101-docker-compose/multiservice-app.png)

This will allow us to choose whatever front-end framework we want and build the client-facing side of the app independently from the API or Database layer. 

We hope you are up for a slight detour into Front-End Land. While we try to stick to container technology, it's important to be well-rounded. Don't worry, we won't ask you to center a `<div>`. 

## Goals for Stream: 
This tutorial will be all front-end, as we build out the first "service" in our multicontainer application. In this tutorial, we will: 

1. Re-build our front-end in VueJS using the NuxtJS framework  
2. Containerize the new front-end 
3. Minify the container

We'll hold off on any form submission, api connections, or CRUD type operations until next time. 

This is a journey to Front-End Land! 

![Hobbit giphy of We're going on an Adventure](https://media4.giphy.com/media/VGG8UY1nEl66Y/giphy.gif?cid=ecf05e47ae4su6381htuvzusi2q4ul4yf2i0k46plo0uzvmx&rid=giphy.gif&ct=g)

# The App
We'll simply be looking to mimic the functionality in the existing app, but do so in a modern, responsive, and slick front-end. 

The front-end application will need to: 

1. Display photos from a folder in a carousel 
2. Allow new photos to be uploaded and displayed
3. Allow the user to categorize images as: `swag`, `cookies`, or `tea` 

## The Tech Stack
We're using a tech stack very similar to the front-end stack we use here at Slim.AI. 

### Why Vue? 
VueJS was created by Evan You and has been rising to prominenance as a React alternative. Vue is a server-side framework meant to be approachable and maintainable, with a focus on testing and interactivity. Vue Components are meant to be highly modular and extensible.  

### Why Nuxt? 
[NuxtJS](https://nuxtjs.org) is an open source project that brings the core concepts of NextJS to a Vue stack. It's focus is to improve developer productivity by providing common tooling and patterns for everything from SEO to performance. 

### Why [Vuetify](https://vuetifyjs.com/en/)?
Front-end developers are designers familiar with Bootstrap will see a lot of similarity with Vuetify. This project is a Material Design library that works with Vue and Nuxt to provide common components, including a grid system, layouts, forms, and even carousels that developers in a beautiful, natively responsive package. 


## Building a Local Nuxt Environment 
To get started, you'll need to have NodeJS and a Node package manager installed (we'll use `npm`). 

### Create a Blank Nuxt Application 
We'll begin by [installing a starter Nuxt app](https://nuxtjs.org/docs/get-started/installation/) that we'll call `frontend`. 

```
$ npm init nuxt-app frontend
``` 

```bash
Need to install the following packages:
  create-nuxt-app
Ok to proceed? (y) 

create-nuxt-app v4.0.0
✨  Generating Nuxt.js project in frontend
```
Follow through the prompts to create the app with the following package selections. Be sure to select `Vuetify` for the UI framework. 

For this project, we'll add a testing framework to use later, but don't worry about CI, dev tools, or linting unless you have preferences there. 

```bash
? Project name: frontend
? Programming language: JavaScript
? Package manager: Npm
? UI framework: Vuetify.js
? Nuxt.js modules: Progressive Web App (PWA)
? Linting tools: ESLint
? Testing framework: Nightwatch
? Rendering mode: Universal (SSR / SSG)
? Deployment target: Server (Node.js hosting)
? Development tools: jsconfig.json 
? Continuous integration: None
? Version control system: Git
```

When completed, you can test by moving to the `frontend` directory and running the dev server. 

```
cd frontend
npm run dev
```

Visiting `localhost:3000` should show us the default Vuetify UI: 

![Screenshot of Default Veutify UI]()

## Writing the App 
A deep dive into the how, what, where, and why of Vue, Nuxt, and Vuetify is outside the scope of this tutorial. (We highly recommend [VueSchool.io](https://www.vueschool.io) to those who want to learn more.) We'll learn just enough to remake our photo app. 

Nuxt projects have a specific project structure that may be intimidating to those new to such frameworks, but fairly intuitive to those coming from React or other JS frameworks. 

```bash
project-dir
|- .nuxt # hidden folder of Nuxt internals
|- assets 
|-- variables.scss 
|- components
|-- NuxtLogo.vue
|-- Tutorial.vue
|-- # add more components here
|- layouts
|-- deafult.vue
|-- error.vue
|-- # add more layouts here
|- pages
|-- index.vue
|-- inspire.vue
|-- # add new pages here
|- static 
|- store 
|- test 
package.json
package-lock.json
nuxt.config.js
... #additional files for testing and deployment configs
```

One of Vue's core concepts is its Components system. Components are designed to be autonomous modules that can be dropped into layouts and operate in a predictable manner. At the highest level, a layout is made up of multiple Component. And Components follow a standard structure: 

```html
<template>
 <!-- your html goes here -->
</template>
<script>
 // your javascript goes here
</script>
<style>
 /* your css goes here */
</style>
```

To early fly in Vue, you'll want to learn way more that we'll do here, such as `scopes`, `v-for` and `v-if` controllers, and data structures.  

For our application, we'll just have two main components -- `Carousel` for our photo carousel and `Uploader` for our upload section -- and put them in a single layout, piggybacking on the default Vuetify pages. 

### Set up 
Your first instinct might be to write the `Carousel.vue` component, and that is what we will do. But first we want to create a place where we can see it and test it. 

Thankfully, we can just follow the patterns established by Nuxt and Vuetify. We already have a Default layout (`layouts/default.vue`) and an index page that's pulling in other pages and components (`pages/index.vue`). 

Let's start by creating a new page in the `pages` file that's a duplicate of the `inspire.vue` page. Let's call it `carousel.vue` to leave room for a more complex UI later on. We can remove the existing html and replace it with `Hello World` so we know we're using that page. 

To get it to show up in UI, we need to add it to our layout in the `<script>` section. There are myriad other ways we could create a new page, but for the sake of our simple front-end, using Vuetify's project set up makes it quick and easy to follow. Note that the route (`/carousel`) needs to match the 

```javascript
items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/'
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
          to: '/inspire'
        },
        // add this
        {
          icon: 'mdi-chart-bubble',
          title: 'Carousel',
          to: '/carousel'
        }
```

Checking `localhost:3000` should show us the new entry in the left nav of the Default Vuetify page. 

### Carousel Component
Here's where the magic of Vue and Vuetify start to become apparent. After all that set up, it will be very simple to add a responsive photo carousel using Vuetify's `<v-carousel>` [UI Component](https://vuetifyjs.com/en/components/carousels/).  

We'll start by creating a `Carousel.vue` Component in the `components` directory, and copy pasta some sample code from the Vuetify docs linked above. 

```
<template>
  <v-row>
    <v-col class="text-center">
      <v-carousel>
        <v-carousel-item
            v-for="(item,i) in items"
            :key="i"
            :src="item.src"
            reverse-transition="fade-transition"
            transition="fade-transition"
            ></v-carousel-item>
        </v-carousel>
  
    </v-col>
  </v-row>
</template>
```

We see a lot of mumbo jumbo working here, but generally can see that we are calling a for loop (`v-for`) that's looking for `items`. Let's add the javascript to provide a list of image urls. 

```
<script>
  export default {
    data () {
      return {
        items: [
          {
            src: '/images/a_codi_socks.png',
          },
          {
            src: '/images/codi_stickers.png',
          },
          {
            src: '/images/codi-tshirts.png',
          },
        ],
      }
    },
  }
</script>
```

The last piece is to be able to call the `<Carousel>` component in our `carousel.vue` file in `pages`. We do that by addeding `<Carousel />` to the html. 

```html
<template>
  <v-card>
    <v-card-title>Slim.AI Containers 101 - Nuxt Frontend</v-card-title>
  
    <v-row>
      <v-col>
      <Carousel />
      </v-col>
    </v-row>
    ...
```

Finally, we need to add some images to the `static` folder (we'll add them to `static/images` for organization) and routes to them in our `<script>` in the Carousel component. **Note:** When we build this into our Compose file, we'll use volumes and a datastore to permanantly store the images, but for now, manually adding them works as a stopgap. 

### Build the Uploader Form
Now that we know how components work, we can quickly build an `Uploader.vue` component using some more built-in Vuetify magic: [Forms](https://vuetifyjs.com/en/components/forms/) and specifically [File Inputs](https://vuetifyjs.com/en/components/file-inputs/). 

```
<template>
    <v-container class="px-0" fluid>
        <v-file-input
            label="File input"
            filled
            prepend-icon="mdi-camera"
            ></v-file-input>

        <v-checkbox
            v-model="checked"
            :label="`Swag`"
        >
        </v-checkbox>
        <v-checkbox
            v-model="unchecked"
            :label="`Cookies`"
        >
        </v-checkbox>

        <v-checkbox
            v-model="unchecked"
            :label="`Cookies`"
        >
        </v-checkbox>

        <v-checkbox
            v-model="unchecked"
            :label="`Tea`"
        >
        </v-checkbox>
    </v-container>
</template>
<script>
export default {
    data () {
      return {
        checked: true,
        unchecked: false
      }
    },
  }
</script>
```

And finally, we add (with a new `<v-row>` and `<v-col>`) the `<Uploader />` component to our `carousel.vue` page. 

# Containerizing the Application 
## Dockerfile 
To containerize a Node-based application is relatively straight-forward. One gotcha is that Nuxt apps must run on an LTS version of Node container, [per the documentation](https://nuxtjs.org/docs/get-started/installation
).

A quick look at the [Node image on the Slim SaaS platform](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fnode%3Alatest
) provides us with some options and insights into the differences between LTS versions. 

```dockerfile
# needs node-lts 
FROM node:lts

RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app/
COPY . .

RUN npm install 

RUN npm run build 

EXPOSE 3000 
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000 

ENTRYPOINT [ "npm", "start" ]
```

There are two environment variables that Nuxt needs (`NUXT_HOST` and `NUXT_HOST`). 

It should build and run no problem, with the new app available at `0.0.0.0:3000`. 

```bash
$ docker build -t photoapp-frontend . 
```


```bash
$ docker run --rm --name frontend -dp 3000:3000 photoapp-frontend
```

# Next Steps 
This front-end isn't functional just yet, just prettier than what we've had so far. We still have some work to do. 

Next stream, we'll do the following: 
   - Update our Docker Compose file to run two services: our previous backend and our new frontend service. 
   - Update our backend to send and receive data needed by the front-end
   - Update our Carousel and Uploader to dynamically read data from the backend API 

We look forward to building with you. 