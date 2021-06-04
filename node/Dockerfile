FROM node:16.0.2
WORKDIR /usr/src/app
COPY package*.json ./

RUN npm ci && npm cache clean --force

USER node

COPY app.js ./

EXPOSE 3000
ENTRYPOINT ["node", "app.js"]
