# Container of the Week: R-Shiny

- [Container of the Week: R-Shiny](#container-of-the-week-r-shiny)
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
The R progamming language grew out of statistical programming languages in the 1970s and saw it's first official release in 1995. However, the langauge spiked in popular in the early 2010s as Big Data and Machine Learning use cases became de facto business needs and AI/ML became more common in computer programming, statistics, and business courses in universities. 

Today, R ranks as the 14th most popular programming language in the world, and is used by hundreds of thousands of developers and data scientsits worldwide. Modern machine learning models are fed to production via Docker containers in most cases, and those containers are notoriously large and tricky to handle. Common ML containers in R or Python will tip the scales at 2GB! The [Rocker Project](https://www.rocker-project.org/) was created by Carl Boettiger and Dirk Eddelbuettel (and is now maintained by them and Noam Ross) to give R users an easy and stable way to Dockerize their R projects. It remains the most popular R-based Docker container. Shiny is a web framework for statistical outputs based on R (for Python users, think of it as a combination of Jupyter notebook and Flask). It's great for graphs, maps, and any kind of data visualization, though can do any flavor of web development. 

This example uses the Rocker base image and the Shiny framework to create a web-based GUI app that can display basic graphs. 

Special thanks to Eric Nantz of the R Podcast for championing this example. 


### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 1.38 GB | 248 MB | 5.7X |
| Total vulernabilities|137 | 0 | inf | 
| Critical vulernabilities| 5 | 0 | inf | 
| Time to Push | 123s | 14s | 8.8X | 
| Time to Scan | 58s | 24s | 2.4X | 
| Time to Build | 610s | 52s | 11.7X |

## About the Container :thinking:
- **Base Image:** Rocker R-Ver
- **Key Frameworks and Libraries:** [R](https://www.r-project.org/) / [#Rstats])https://twitter.com/hashtag/rstats), [Shiny]/(https://shiny.rstudio.com/)  
- **Base Image Size:** 825 MB
- **Slim.AI Profile:** ['rocker/r-ver'](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Frocker%2Fr-ver%3A4.0.4)
- **Common Use Cases:** Data visualization, statistics, statistical programming 

## Our Sample App 
We're using a standard `Hello World` example from the R Shiny library. Our project folder will look like this for a standard Shiny app: 

```
hello-world
Dockerfile
| service
| | app.R
```
The `app.R` file has a basic app built by Eric Nantz. Eric and Slim.AI Head of Community Martin Wimpress have used a version of this app in their Hot Rod Racing Twitch stream to choose a car at random. This version displays a graph with a normal distribution. 

``` R 
## app.R ##
library(shiny)
server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs), col = 'darkgray', border = 'white')
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

obj <- shinyApp(ui = ui, server = server, options = list(host='0.0.0.0', port = 7123))
shiny::runApp(appDir = obj, launch.browser = FALSE)
```
### Dockerfile
Our Dockerfile uses the Rocker project's `r-ver` version as a base image. It installs several security updates and dependencies in the first line, then runs a command in the container to download various required libraries like R Studio, CURL, and Shiny.

Finally it copies the app.R file and directory (Shiny apps need to be run out of their own directories), exposes a typical R port (7123), and runs the app via `ENTRYPOINT`. 

``` Dockerfile
FROM rocker/r-ver:4.0.3
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("shiny")'

COPY service /opt/my/service
WORKDIR /opt/my/service

EXPOSE 7123
ENTRYPOINT ["R","-e source('/opt/my/service/app.R')"]
```


### Testing Original Container
We build the container from the `hello-world` directory (you can rename this to whatever you want) with the following command. We'll name it, per our conventions, as `cotw-rshiny-hello`. 

```
$ docker build -t cotw-rshiny-hello .
``` 

Now, go make some coffee, find a good book, perhaps start that kitchen renovation you've been putting off, because this takes a long time. On our Threadripper-based, 64MB Linux machine, the build took 8 minutes and 13 seconds, and the base image is 1.3 GB. Pretty hefty for a "Hello World!" example. 

```
$ docker images
REPOSITORY                       TAG       IMAGE ID       CREATED         SIZE
cotw-rshiny-hello                latest    1b65cee157d3   2 minutes ago   1.3GB
```

On the plus side, we can test the image by running it and trying it in a browser window by visiting `localhost:7123`

```
$ docker run -dp 7123:7123 --name cotw-rshiny-hello-fat cotw-rshiny-hello 
```

And we see something that looks like... 

![R Hello World app](/images/appRscreenshot.png)



## Slimming The Image :mechanical_arm:
TK Stuff here about include paths 

TK Stuff here about debugging 

TK Stuff here about using the image manually 

```
docker-slim  build --target cotw-rshiny-hello --show-clogs  --include-path-file 'build_recipe/r_path_includes' --publish-port 7123 --http-probe=false
```

#### Using an include file
DockerSlim has several methods for flagging parts of the container that should be included no matter what. Multiple files, directories, or user:group designations can be flagged in the command line such as `--include-path /etc` or `--include-path /somedir/somelibrary`. Since R and Shiny have a fairly robust number of libraries that we're using in this example, we use the `--include-path-file build_recipe/r_path_includes` to load all of our "Don't Touch!" files to DockerSlim in a convenient format. 

For this example, we used the error logs produced by R and the Explorer tab in the [Slim Developer Portal](https://www.slim.ai/blog/slim-developer-platform-web-portal.html) to search for libraries, files, and directories required for our sample app to work. Future iterations of Slim.AI will further simplify this discovery process. 
```
/.dockerenv
/libx32
/lib64
/lib32
/sbin
/usr/include/c++
/usr/local/lib/R/library/graphics
/usr/local/lib/R/library/man
/usr/local/lib/R/library/compiler
/usr/local/lib/R/library/methods
/usr/local/lib/R/library/stats
/usr/local/lib/R/library/datasets
/usr/local/lib/R/library/grDevices
/usr/local/lib/R/library/utils
/usr/local/lib/R/library/compiler
/usr/local/lib/R/library/tools
/usr/local/lib/R/site-library
/usr/local/lib/R/modules
```

## Results :raised_hands:

### Test Run 
  To test the new container, we'll first remove the original container so we don't get a false positive when checking our results in our browser.
  ```bash
    docker rm cotw-rshiny-hello-fat
  ```
  We can then run the new container using the same command as before,
  ```bash
   docker run -dp 7123:7123 --name cotw-rshiny-hello cotw-rshiny-hello.slim
  ```
  Refreshing localhost:7123 reveals an identical web page to our previous, looks like everything is intact!
### Is the container smaller and more secure?
  Not only have we reduced build times by slimming the container size by 5.7x, we have also significantly reduced attack surface; our vulnerability scan using [Grype](https://github.com/anchore/grype) reveals we no longer have any critical issues!
