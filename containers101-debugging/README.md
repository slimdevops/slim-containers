# Containers 101 - Part 4: Debugging

# Introduction
Happy Halloween, Slimmers! We need your help. Our PyPhotoApp container has been cursed by an evil Ghost Pirate, and we need to :spider: debug it :spider:. 

We'll be following the tips found in [our blog post](https://www.slim.ai/blog/five-proven-ways-to-debug-a-container.html) to cast a magic healing spell on this version of our container: `slimpsv/pyphotoapp:cursed`. 

[Five Proven Ways to Debug a Container from Slim.AI](https://www.slim.ai/blog/five-proven-ways-to-debug-a-container.html) 

# The App
The app is the same app as we did in [the container volumes tutorial](https://github.com/slimdevops/slim-containers/tree/master/containers101-volumes), with some twists and turns. 

The expected output is a photo slide show. Getting the container to run as expected, however, is a ghoulish experience. 

# Issues we face
Our container has quite a few issues as a result of the curse. Here's a list. 

To test our image, we'll primarily use two commands. Do this from the `pyphotoapp` directory on your local machine. 

Building the image from the `Dockerfile`: 
``` docker build -t slimdevops/pyphotoapp:cursed . ```

Running the image in `interactive mode` (we add the `--rm` flag so we remove the conatiner): 
``` docker run -it -p 5000:5000 --rm slimdevops/pyphotoapp:cursed ```

Visiting our app in a browser to test the results: 
``` http://0.0.0.0:5000 ```


## Test Error: Magic FLASK not found
It looks like we are trying to run `test.py` to make sure our dependencies are installed as desired. But something is wrong. 

Let's look at our layer construction using `docker-slim xray` or the Slim SaaS. 

## Cursed CMDs
The test issue has gone away, but when we check our app in the browser, it's still cursed. What's going on with our `ENTRYPOINT` and `CMD` lines? 

We can use `docker pause` and `docker inspect` here to get more info. 

## Container starts but we get a permissions issue
We've gotten over that jinx but now we have a new issue. We get a file error when running our app. Hrmm. 

For this one, let's run our container as a daemon: 
```docker run -dp 5000:5000 --rm --name cursed slimdevops/pyphotoapp:cursed ```

Now, let's search the `docker logs cursed` to see what the application has said. 

Next, let's exec into the running container to see what those permissions issues might be. 

## The curse is lifted! 
Thanks noble warriors! 

~[](pyphotoapp/static/images/happy_halloween.png)

Have tricks or treats for debugging your containers? [Join our Discord and please share!](https://discord.gg/uBttmfyYNB)


### Container Starts But Application doesn't run (use docker logs to find root issue; update Dockerfile for permissions)
USER_ID and GROUP_ID are set as environ variables in test.py 
DOckerfile looks innocent -- setting user id variables as you'd like it to
However, chmodd'ing app.py leads to some odd behavior

docker exec -it <container_name> /bin/bash 
ls -la to see files and permissions
refer to article: fix is to pass USER_ID and GROUP_ID variables to container:
docker run -dp 5000:5000 slimdevops/

### Something about using paused containers


# Fixes



