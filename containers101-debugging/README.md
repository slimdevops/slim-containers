# Containers 101 - Part 4: Debugging

# Introduction
Happy Halloween, Slimmers! We need your help. Our PyPhotoApp container has been cursed by an evil Ghost Pirate, and we need to :spider: debug it :spider:. 

We'll be following the tips found in [our blog post here](https://www.slim.ai/blog/five-proven-ways-to-debug-a-container.html) to cast a magic healing spell on this version of our container: `slimdevops/pyphotoapp:haunted`. 

# The App
The app is the same app as we did in [the container volumes tutorial](https://github.com/slimdevops/slim-containers/tree/master/containers101-volumes).

# Issues we face

### Won't start (bad layer construction, running test before installing dependencies)
bad layer construction
run: docker-slim xray slimdevops/pyphotoapp:cursed 

### Strange Startup Behavior (entrypoint command in Dockerfile)
app.py gets overwritten by jinx.py
docker run -it -p 5000:5000 --rm slimdevops/pyphotoapp:cursed 
hit: http://0.0.0.0:5000/
can use docker pause and inspect here 

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



