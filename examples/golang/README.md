# Container of the Week: GoLang

- [Container of the Week: GoLang](#container-of-the-week-GoLang)
  - [Introduction :wave:](#introduction-wave)
    - [TL;DR:](#tldr)
  - [About the Container :thinking:](#about-the-container-thinking)
  - [Our Sample Image](#our-sample-image)
    - [Testing Original Container](#testing-original-container)
  - [Slimming The Image :mechanical_arm:](#slimming-the-image-mechanical_arm)
      - [Using an exec file](#using-an-include-path)
  - [Results :raised_hands:](#results-raised_hands)
    - [Success Criteria](#success-criteria)
    - [Test Run](#test-run)
    - [Image Size](#image-size)
    - [Security Scan](#security-scan)

---
## Introduction :wave:
Today we are going to be slimming an example app on a container built using the Golang. The [app](https://github.com/gscho/simple-go-app) is a basic introductory setup which simply sends the hostname to a host port. Go, released in 2012, has been steadily increasing in popularity, most recently landing in [13th place](https://www.itproportal.com/features/golang-why-should-you-choose-this-language/#:~:text=In%20Popularity%20of%20Programming%20Language,13th%20place%20out%20of%2028.) for popular programming languages. It is known for its highly effective handling of concurrency, largely owed towards its efficient approach to thread-management using "goroutines". In fact, the CLI that we will be using to slim this container is itself written using Golang.

### TL;DR:
We were able to slim the original 893 MB app container to 138 MB, a more than 6X size improvement. According to our scans on the [Slim SaaS Platform](https://portal.slim.dev/home), we managed to remove 777 vulnerabilities from the container!

## About the Container :thinking:
- **Base Image:** golang:1.14.2
- **Key Frameworks and Libraries:** [Go](https://go.dev/)
- **Base Image Size:** 809 MB
- **Slim.AI Profile:** ['Go'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fgolang%3Alatest)
- **Common Use Cases:** Microservice architectures, cloud platform development, Command Line Interfaces

## Our Sample Image

We'll build our container image from an offical golang base image, setup our working directory, and then run the main file.

```Dockerfile
FROM golang:1.14.2

WORKDIR /go/app

ADD . .

RUN go get .

CMD ["go", "run", "main.go"]
```

We can build our image from this Dockerfile using this command.

```bash
docker build -t go-simple .
```

Our container is now ready to run.

### Testing Original Container

When running the container, we should be sure to expose our container ports to the ports of our host machine so we can properly test our container.

```bash
docker run -dp 8080:8080 --name gsc go-simple
```

Visiting localhost:8080 shows us that our service is working as expected; you can also test this quicker using curl.

```bash
$ curl localhost:8080
{"hostname":"897cae0bd79d"}
```

Be sure to use docker kill gsc and docker rm gsc to clean up after testing.


## Slimming The Image :mechanical_arm:

Now that we have our working image, we can move on to slimming. This docker-slim build command should do the trick.

```bash
docker-slim build --expose 8080 --publish-port 8080:8080 --target simple-go
```
We've exposed and published the port our app uses, so our http probe should be able to identify everything we need. The build executes, we run the container using our previous run command, pop open localhost:8080, and...
<img src="https://github.com/slimdevops/slim-containers/blob/main/images/local-no-connect.PNG" alt="Your image title" width="500"/>

What's going on here? We didn't receive any error messages, yet our app is clearly not working as intended. Entering docker ps into the command line reveals that the container isn't even running- something caused it to terminate early. One way we can go about figuring out what went wrong is running the container in interactive mode in the foreground, using this command.

```bash
docker run -itp 8080:8080 simple-go.slim
```

Once running, our console outputs these lines, and then the container terminates within just a few seconds.

```bash
go: downloading github.com/ugorji/go v1.1.7
# golang.org/x/sys/unix
../pkg/mod/golang.org/x/sys@v0.0.0-20200116001909-b77594299b42/unix/asm_linux_amd64.s:8: #include: open /usr/local/go/pkg/include/textflag.h: no such file or directory
```
Despite being able to build our container, our app build has failed because go is missing a necessary file. Fortunately, Dockerlsim provides an easy way to correct this.

### Using an include path

We can re-run Dockerslim build, using the flag --include-path to make sure that the slim image contains the missing file.

```bash
docker-slim build --include-path /usr/local/go/pkg/include/textflag.h  --expose 8080 --publish-port 8080:8080 --target simple-go
```

## Results :raised_hands:

### Test Run 

Firing up new slim container, fingers crossed.

```bash
$ curl localhost:8080
{"hostname":"897cae0bd79d"}
```

Everything working as expected!

### Is the container smaller and more secure?

After pushing these images up to Dockerhub and running some comparison scans using the Slim SaaS portal, we are met with some promising results!

  ![Go Vuln Diff](/images/go-vuln.PNG)


Stay tuned- we have a tutorial coming on slimming Go apps that use MongoDB!


