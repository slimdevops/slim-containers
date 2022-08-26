#!/bin/bash
image_name=ruby3-rails7-hello-world-api
docker build -t $image_name .

#Resuires docker-slim: https://github.com/docker-slim/docker-slim
docker-slim build \
--target=$image_name \
--http-probe=true \
--http-probe-cmd /hello \
--include-path /usr/src/app \
--expose 3000

#Requires grype: https://github.com/anchore/grype
grype $image_name.slim > $image_name.slim.vul.txt
grype $image_name > $image_name.vul.txt