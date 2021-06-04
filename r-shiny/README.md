# Container of the Week: R-Shiny

- [Container of the Week: R-Shiny](#container-of-the-week-r-shiny)
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
| Size | 1.29 GB | 225 MB | 5.8X |
| Total vulernabilities| TK | TK | TK | 
| Critical vulernabilities| TK | TK | TK | 
| Time to Push | TKmTKs | TKmTKs | TK X | 
| Time to Scan | TKmTKs | TKmTKs | TK X | 

## About the Container :thinking:
- **Base Image:** Rocker R-Ver
- **Key Frameworks and Libraries:** [R](https://www.r-project.org/) / [#Rstats])https://twitter.com/hashtag/rstats), [Shiny]/(https://shiny.rstudio.com/)  
- **Base Image Size:** 825 MB
- **Slim.AI Profile:** ['rocker/r-ver'](https://portal.slim.dev/home/xray/dockerhub%3A%2F%2Fdockerhub.public%2Frocker%2Fr-ver%3A4.0.4)
- **Common Use Cases:** Data visualization, statistics, statistical programming 

## Our Sample App 




### Dockerfile
This Dockerfile was produced for this example by Eric Nantz of [R-podcast](https://r-podcast.org/) (thanks Eric!) and can be found at his [GitHub repo](https://github.com/rpodcast/). The build script starts with the popular Rocker R-Ver variety, makes some apt-get updates and then installs R Studio and Shiny before copying the `/service` app directory and relevant files like `app.R` into the image. It then exposes the port `7123` (common usage in Shiny applications) and runs the app using the `R` command via a Docker `ENTRYPOINT`. 

```
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
``` bash
$ docker run -dp 7123:7123 --name shiny_container johnnyslim/slimtest:r_shiny
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS              PORTS                    NAMES
6eb18cdb23f8   johnnyslim/slimtest:r_shiny   "R '-e source('/opt/…"   About a minute ago   Up About a minute   0.0.0.0:7123->7123/tcp   shiny_container
```


## Slimming The Image :mechanical_arm:

```
docker-slim  build --target johnnyslim/slimtest:r_shiny --show-clogs  --include-path-file 'build_recipe/r_path_includes' --publish-port 7123 --http-probe=false
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
### Success Criteria
- Application should still run
- Container should be smaller than the original
- Container should be safer than the original 
  
### Test Run 
### Image Size
### Security Scan 
