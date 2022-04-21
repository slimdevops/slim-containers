FROM node:16.14.2
WORKDIR /usr/src/app
COPY package*.json ./

RUN npm ci 

USER node

COPY app.js ./

EXPOSE 3000
ENTRYPOINT ["node", "app.js"]
