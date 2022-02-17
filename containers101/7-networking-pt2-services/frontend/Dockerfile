# needs node-lts 
FROM node:lts

RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app/
COPY . .

RUN npm ci 

RUN npm run build 

EXPOSE 3000 
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000 

ENTRYPOINT [ "npm", "start" ]

