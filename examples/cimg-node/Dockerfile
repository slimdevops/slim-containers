FROM cimg/node:18.7.0

USER root

WORKDIR /app

RUN npm install -g contentful-cli

COPY package.json .
RUN npm install

COPY . .

USER circleci

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
