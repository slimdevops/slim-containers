# Container of the Week: Rust's Guessing Game Tutorial>

- [Container of the Week: <Rust / Guessing Game Tutorial>](#container-of-the-week-frameworkcontainer-name)
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
## Introduction to the Rust Container:wave:

Today we are going to be slimming an example app on a container built using the Rust programming language. The app is a simple guessing game - you can find the code for it along with a detailed walkthrough on the Rust Programming Language docs [here](https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html). An open source language, Rust has found popularity since its release and has been consistently ranked as [the most loved programming language by developers](https://www.turing.com/blog/rust-is-the-most-popular-programming-language/#:~:text=According%20to%20a%20survey%20by,the%20developer%20community%20since%202015.&text=According%20to%20The%20News%20Stack,likes%20of%20Python%20and%20TypeScript.). Its fast performance and modern features have made it an increasingly popular alternative to C++ as a general-purpose language.

### TL;DR:
In this example, our Rust app using the latest Rust image weighs in at **1.45 GB** and contains a whopping **1077 vulnerabilities** according to security scan  by [Grype vulnerability scanner](https://github.com/anchore/grype), including 32 critical issues. Our slimmed container provides the same REST app, but is just **10 MB** and has **ZERO** vulnerabilities .

### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 1485 MB | 10 MB | 148.5 X |
| Total vulernabilities| 1077 | 0 | inf | 
| Critical vulernabilities| 32 | 0 | inf | 
| Time to Push | 133s | 4s | 33.3 X | 
| Time to Scan | 12s | 1s | 12.0 X | 
| Time to Build | 174s | 12s | 14.5 X | 

## About the Container :thinking:
- **Base Image:** Rust (Official Docker Image)
- **Key Frameworks and Libraries:** [Rust](https://www.https://www.rust-lang.org/)
- **Base Image Size:** 1.45 GB (Uncompressed)
- ['Slim.AI Profile'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Frust%3A)
- **Common Use Cases:** High-performing compiled applications, back-end services, and APIs

## Our Sample App 
https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html

Before you dockerize the app, you should include a Cargo.toml file in your project folder. Cargo is Rust's build system and package manager which will track your apps dependencies when you build it.

```toml
[package]
name = "guessing-game"
version = "0.1.0"
edition = "2018"
author = "Slim-PSV" 

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
rand = "0.8.3" 
```
Your project folder should now look like this.

```bash
Dockerfile
Cargo.toml
/src
|- main.rs
```

### Dockerfile


## Slimming The Image :mechanical_arm:

## Results :raised_hands:

### Success Criteria
### Image Size
### Security Scan 
