# Container of the Week: Mongo

- [Container of the Week: Mongo](#container-of-the-week-mongo)
  - [Introduction :wave:](#introduction-wave)
    - [TL;DR:](#tldr)
  - [About the Container :thinking:](#about-the-container-thinking)
  - [Our Sample Image](#our-sample-image)
    - [Testing Original Container](#testing-original-container)
  - [Slimming The Image :mechanical_arm:](#slimming-the-image-mechanical_arm)
      - [Using an exec file](#using-an-exec-file)
  - [Results :raised_hands:](#results-raised_hands)
    - [Success Criteria](#success-criteria)
    - [Test Run](#test-run)
    - [Image Size](#image-size)
    - [Security Scan](#security-scan)

---
## Introduction :wave:
Today, rather than slimming an example application, we're going to be see what we can do to slim the MongoDB official [Mongo](https://hub.docker.com/_/mongo) image. Particularly, our goal is to harden our container for production, cutting out as many vulnerabilities as unnecessary dependencies as possible, while still keeping all the operability of the Mongo shell.


### TL;DR:

In this example, the latest Mongo image weighs in at 697 GB and contains a 45 vulnerabilities according to security scan by Grype vulnerability scanner. Our slimmed container still provides the Mongo shell, but is less than half of the size.

## About the Container :thinking:
- **Base Image:** Mongo
- **Key Frameworks and Libraries:** [MongoDB](https://www.mongodb.com//)
- **Base Image Size:** 697 MB
- **Slim.AI Profile:** ['Mongo'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fmongo%3Alatest)
- **Common Use Cases:** Real-time data integration, product catalogues, analytics

## Our Sample Image 

We can get Mongo:latest using a simple pull command.

```bash
docker pull mongo
```

### Testing Original Container

When running the container, if we want to use it we'll need to expose port 27017.

```bash
docker run -d -p 27017:27017 --name mongo-test mongo:latest
```

To use the container's shell, we'll use docker exec to enter bash inside the container. The -it tag will allows us to use the container in interactive mode.

```bash
docker exec -it mongo-slim bash
```

Inside the container, we can use the command 'mongo' to connect to advance into the mongo shell. You can then use the 'help' to see what commands you can use inside or visit the official [reference](https://www.mongodb.com/docs/manual/reference/mongo-shell/).

Be sure to use docker kill and then docker rm to get rid of the old container once you're done using it.

## Slimming The Image :mechanical_arm:

Our typical first-run approach for slimming containers with Dockerslim is to allow the http-probe, which is enabled by default, to do our work.

```bash
docker-slim build --target mongo:latest
```
At first this seems like a success: the build completes, a mongo.slim image appears, and it's only 243 MB. 
However, when we test the new container, we'll find that we are met with an error.

```bash
bash-5.0# mongo
bash: mongo: command not found
```
What went wrong? Its hard to say, but in most cases this kind of issue can be fixed in two ways. One approach is to indentify the directories that the http probe missed and then use the --include-path <File path> to fix it. The other, which we will use today, is to disable the http-probe and interact with the container ourselves. This can be thought of as manually probing the container.

```bash
docker-slim build --target mongo:latest --http-probe-off --publish-exposed-ports
```
These extra flags disable the probe and publish the exposed ports to our host machine- we'll need them to interact with the container ourselves. During the build, we'll be met with a message telling us that user input is required to continue. Docker-slim has created and run a mongo container in an observation mode. When we interact with this container, Docker-slim will collect data on the components that we use to include in the slim container. Before hitting enter to continue, we should open another terminal and use docker ps to find the container ID. Once we have it, we'll use the same exec command with the new ID to enter. Executing "mongo" in the command line will inform Docker-slim that the directories necessary to running the mongo shell should be included in the slim image. We can now hit enter on our other terminal and finish the build.

### Using an exec file

Interacting with the container manually leaves room for human error which could create problems with reproducability in our builds. Fortunately, Dockerslim has a flag which allows us to provide a file with the commands we want executed in our temporary container. All we need to do is throw the commands we used into an executable bash file and pass it into our build command!

```bash
#probe_commands.sh
bash
mongo
```
Our final build command should look like this.
  
```bash
docker-slim build --target mongo:latest --http-probe-off --publish-exposed-ports --exec_file probe_commands.sh
```

## Results :raised_hands:

### Test Run 
Running the container and entering mongo as we did before reveals that we still have full access to the Mongo shell!
  
### Is the container smaller and more secure?
Our new image is less than half the size of the original. Along with saving times on uploads, scans, and builds, we know that our attack surface is now signficantly reduced. For some extra analysis, the [Slim SaaS portal](https://portal.slim.dev/home) allows us to compare images, which is always good to do after slimming (this feature is free and now available to ALL users!). A quick push to dockerhub and we're able to get reports on the differences in the filesystem, metadata, dockerfile, and vulnerabilities of our original and hardened images. Here's a peak at the vulnerability diff report - feel free to check out the others on the portal. 
  ![Mongo Vuln Diff](/images/mongo-vulns.PNG)

Stay tuned- we have a tutorial coming on slimming Go apps that use MongoDB!
