# Slim Starter Pack: nginx Static 'Hello World' Version
[![https://www.slim.ai/](https://img.shields.io/badge/Slim.AI-Starter%20Kit-9cf)](https://www.slim.ai/)
[![https://hub.docker.com/](https://img.shields.io/badge/DockerHub-Image-blue)](https://hub.docker.com/)

Hello nginx and static website developers! 

Optimize and harden your containerized applications the easy way — with Slim.AI. 

This Starter Kit will help you proactively remove vulnerabilities from your applications. 

Simply replace the application code here with your own application, run it through Slim.AI's [automated container optimization](https://www.slim.ai/docs/optimization) process, and you'll remove up to 0-percent of the image's vulnerabilities while also making it up to 11.83X smaller. 

No more chasing down hard to patch vulns that your application isn't even using, and you can use any base image you want — even `nginx:latest`. 

# Optimization Results
![Result of optimized Nginx image](results.png)

Slimming this nginx container results in 0 to 1-percent reduction in overall vulnerabilities. 

## Vulnerability difference by severity 

[See the full report.](https://www.slim.ai/starter-kits/dot-net)

# Get Started
To start a nginx application application, you'll need the following libraries installed locally, or running in a dev environment link GitPod, Docker Environments, or Code Spaces. 


``` 
nginx:latest
```


## Sample Application
Our sample application is a simple static page serve that merely returns "Hello World" html document.

While this app is simple, it's a great starting point for more complex development. 

Project structure
```
├── config
│   └── nginx.config
├── content
│   └── index.html
├── Dockerfile
├── README.md
```

Code sample
``` conf
    server {
        listen 80;
        server_name frontend.com;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
```

Replace this placholder code with your own application code, and install any necessary dependencies, to create your own slimmable container. 

## Sample Dockerfile
Our Dockerfile builds off of the `mcr.microsoft.com/dotnet/sdk:6.0` image and starts at **142MB**. The slimming process reduces the size by **11.83X** to just **12MB**. 

![Graph of size reduction](results-size.png)

[See the full report on Slim.AI](https://portal.slim.dev/... )