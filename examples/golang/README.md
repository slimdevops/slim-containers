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


### TL;DR:


## About the Container :thinking:
- **Base Image:** golang:1.14.2
- **Key Frameworks and Libraries:** [Go](https://go.dev/)
- **Base Image Size:** 809 MB
- **Slim.AI Profile:** ['Go'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fgolang%3Alatest)
- **Common Use Cases:** 

## Our Sample Image 

### Testing Original Container



## Slimming The Image :mechanical_arm:

Now that we have our worknig image, we can move on to slimming. This docker-slim build command should do the trick.

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

### Is the container smaller and more secure?


Stay tuned- we have a tutorial coming on slimming Go apps that use MongoDB!


