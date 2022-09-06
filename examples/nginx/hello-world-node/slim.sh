#!/bin/bash
image_name1=nginx-node-hello-nginx-server
image_name2=nginx-node-hello-node-server
docker build -t $image_name1 .
docker build -t $image_name2 .

#Resuires docker-slim: https://github.com/docker-slim/docker-slim
docker-slim build \
--compose-file=docker-compose.yml \
--target=$image_name1 \
--http-probe=true \
--expose 80

#Requires grype: https://github.com/anchore/grype
# grype $image_name.slim > $image_name.slim.vul.txt
# grype $image_name > $image_name.vul.txt