FROM node:latest

RUN apt-get update && apt-get upgrade 
RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app/
COPY . .

RUN npm install 

RUN npm run build 

EXPOSE 5000 
ENV NUXT_HOST=0.0.0.0

ENV NUXT_PORT=5000 

ENTRYPOINT [ "npm", "start" ]

