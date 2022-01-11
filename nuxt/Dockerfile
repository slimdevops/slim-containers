# errors if you use node latest -- nuxt conflict? 
FROM node:14.18.2 

RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app/
COPY . .

# should be npm ci? 
RUN npm install 

RUN npm run build 

EXPOSE 5000 
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=5000 

ENTRYPOINT [ "npm", "start" ]

