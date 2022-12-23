# Slim Starter Pack: PHP
[LINK TO SLIMAI](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fphp%3Alatest)
[LINK TO IMAGE ON DOCKERHUB](https://hub.docker.com/_/php)

Attention PHP developers! 

Optimize and harden your containerized applications the easy way — with Slim.AI. 

This Starter Kit will help you proactively remove vulnerabilities from your applications. 

Simply replace the application code here with your own application, run it through Slim.AI's [automated container optimization](https://www.slim.ai/docs/quickstart) process, and you'll remove up to 90% of the image's vulnerabilities. 

No more chasing down hard to patch vulns that your application isn't even using. 

# Optimization Results

## Overall results
![Result of minify PHP](php-results.png)

Slimming this httpd container resulted in a more than 5X minification factor!

In the process, we have eliminated all of our detected vulnerabilities!
# Get Started
To start this PHP application, all you will need is a running Docker daemon and a cloned version of this repository. Our sample application is a simple Hello-World Apache web server.
```Dockerfile
|- Dockerfile
|-src
|-- index.php
```

Replace this placeholder code with your own application code, and install any necessary dependencies, to create your own slimmable container. 

## Sample Dockerfile
Our original Dockerfile builds off of the `httpd:2.4` image to create the pre-hardened app.

```Dockerfile
FROM php:7.0-apache
COPY src/ /var/www/html
EXPOSE 80
```

From there, it's a simple command to run the app and check out the webpage!

```bash
docker run -dp 80:80 <container image name>
```

Just visit localhost:80 to see the results for yourself!
