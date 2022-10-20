# Slim Starter Pack: .Net Core 'Hello World' Version
[![https://www.slim.ai/](https://img.shields.io/badge/Slim.AI-Starter%20Kit-9cf)](https://www.slim.ai/)
[![https://hub.docker.com/](https://img.shields.io/badge/DockerHub-Image-blue)](https://hub.docker.com/)

Hello .Net Core developers! 

Optimize and harden your containerized applications the easy way — with Slim.AI. 

This Starter Kit will help you proactively remove vulnerabilities from your applications. 

Simply replace the application code here with your own application, run it through Slim.AI's [automated container optimization](https://www.slim.ai/docs/optimization) process, and you'll remove up to 100-percent of the image's vulnerabilities while also making it up to 8.82X smaller. 

No more chasing down hard to patch vulns that your application isn't even using, and you can use any base image you want — even `mcr.microsoft.com/dotnet/sdk:latest`. 

# Optimization Results
![Result of optimized Rails image](results.png)

Slimming this Rails container results in 100-percent reduction in overall vulnerabilities. 

## Vulnerability difference by severity 

[See the full report.](https://www.slim.ai/starter-kits/dot-net)

# Get Started
To start a .Net Core application application, you'll need the following libraries installed locally, or running in a dev environment link GitPod, Docker Environments, or Code Spaces. 


``` 
dotnet-sdk:6.0
```

To run locally use:
```
dotnet run
```

## Sample Application
Our sample application is a simple REST API that merely returns "Hello World" JSON.

While this app is simple, it's a great starting point for more complex development. 

Project structure
```
├── appsettings.Development.json
├── appsettings.json
├── Controllers
│   └── HelloWorldController.cs
├── Dockerfile
├── HelloApi.csproj
├── HelloWorld.cs
├── Program.cs
├── Properties
│   └── launchSettings.json
├── README.md
```

Code sample
``` c# 
    [HttpGet(Name = "HelloWorld")]
    public HelloWorld Get()
    {
        return new HelloWorld
        {
            Date = DateTime.Now,
            Hello = "World !"
        };
    }
```

Replace this placholder code with your own application code, and install any necessary dependencies, to create your own slimmable container. 

## Sample Dockerfile
Our Dockerfile builds off of the `mcr.microsoft.com/dotnet/sdk:6.0` image and starts at **781MB**. The slimming process reduces the size by **8.82X** to just **88MB**. 

![Graph of size reduction](results-size.png)

[See the full report on Slim.AI](https://portal.slim.dev/... )