#!/bin/bash
image_name1=johnnyslim/dcexample:nginx
image_name2=johnnyslim/dcexample:node
docker build -t $image_name1 .
docker build -t $image_name2 ./node-app/.

#Resuires docker-slim: https://github.com/docker-slim/docker-slim
# docker-slim build \
# --compose-file=docker-compose.yml \
# --target=$image_name1 \
# --http-probe=true \
# --expose 80

#Requires grype: https://github.com/anchore/grype
# grype $image_name.slim > $image_name.slim.vul.txt
# grype $image_name > $image_name.vul.txt
