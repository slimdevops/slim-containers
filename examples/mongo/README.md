# Container of the Week: Mongo

- [Container of the Week: R-Shiny](#container-of-the-week-mongo)
  - [Introduction :wave:](#introduction-wave)
    - [TL;DR:](#tldr)
    - [Results Summary :chart_with_upwards_trend:](#results-summary-chart_with_upwards_trend)
  - [About the Container :thinking:](#about-the-container-thinking)
  - [Our Sample App](#our-sample-app)
    - [Dockerfile](#dockerfile)
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


### TL;DR:
### Results Summary :chart_with_upwards_trend:
| Test | Original Image | Slim Image | Improvement | 
|----- | ----- | ---- | ---- | 
| Size | 697 GB | 401 MB | 0 X |
| Total vulernabilities|0 | 0 | 0 X | 
| Critical vulernabilities| 0 | 0 | 0 X | 
| Time to Push | 0s | 0s | 0 X | 
| Time to Scan | 0s | 0s | 0 X | 
| Time to Build | 0s | 0s | 0 X |

## About the Container :thinking:
- **Base Image:** Mongo
- **Key Frameworks and Libraries:** [MongoDB](https://www.mongodb.com//)
- **Base Image Size:** 825 MB
- **Slim.AI Profile:** ['Mongo'](https://portal.slim.dev/home/profile/dockerhub%3A%2F%2Fdockerhub.public%2Flibrary%2Fmongo%3Alatest)
- **Common Use Cases:** Real-time data integration, product catalogues, analytics

## Our Sample App 


### Dockerfile




### Testing Original Container




## Slimming The Image :mechanical_arm:

### Using an exec file


## Results :raised_hands:

### Test Run 
 
### Is the container smaller and more secure?
