# errors if you use node latest -- nuxt conflict? 
# needs node-lts 
FROM node:lts-slim

RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app/
COPY . .

# should be npm ci? 
RUN npm install 

RUN npm run build 

EXPOSE 3000 
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000 

ENTRYPOINT [ "npm", "start" ]

