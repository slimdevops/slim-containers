# Exploring Docker Slim with R Docker containers

This repository contains explorations of using the [Docker Slim](https://github.com/docker-slim/docker-slim) project to minify Docker containers wrapping the R language for statistical computing. In the R community, containerized workflows are now becoming an important part of computing environment reproducibility, and a step forward to leveraging better software development best practices.  The [Rocker](https://www.rocker-project.org/) project is considered the standard bearer for hosting robust Docker containers enabling many workflows and capabilities of R in data science. The examples in this repository are Shiny web application,s which operates in a similar fashioin as a Python Flask or Dash application within the following subdirectories:

* `small_app`: This is a very minimal Shiny application. It has been constructed to mirror as close as possible the structure of the [python2_flash_ubuntu14](https://github.com/docker-slim/examples/tree/master/python2_flask_ubuntu14) example from the Docker-Slim example repository.
* `big_app`: This is a much bigger Shiny app that mimics real-world usage. The `Dockerfile` of the app was actually generated automatically from another R package called [`golem`](https://github.com/ThinkR-open/golem) that helps bundle the application as an actual R package.  Fun fact: This application has been used in Martin's [Linux gaming streams](https://youtu.be/ow8A68ElPp0?t=525) to help select a car at random for HotShot Racing competitions!

## Development Notes

Here are the steps I followed to at least attempt minifying the Docker container built from the `small_app`:

1. Clone the repository and navigate to the `small_app` directory
1. (If necessary) Install Docker on a standard Ubuntu 20.04 distribution from the standard Ubuntu repositories
1. (If necessary) [Install Docker Slim](https://github.com/docker-slim/docker-slim#installation) on host system
1. Build the R container in the app directory: `docker build -t my/simple-shiny-app .`
1. Verify that the Shiny application renders correctly by visiting `localhost:7123` in your browser after running the container: `docker run -it --rm -p 7123:7123 my/simple-shiny-app` 
1. Run Docker Slim to minify the container: `docker-slim build --copy-meta-artifacts . my/simple-shiny-app`
1. Verify that the Shiny application renders correctly in the slimmed container by visiting `localhost:7123` in your browser after running the container: `docker run -it --rm -p 7123:7123 my/simple-shiny-app.slim` 

## Current status

The `docker-slim build` command above is able to complete a build. However, the container cannot be run correctly. The error I receive is below:

```
eric@xps9300 ~/s/hotshots.random (main)> docker run -it --rm -p 7123:80 my/sample-shiny-app.slim
standard_init_linux.go:219: exec user process caused: no such file or directory
```

