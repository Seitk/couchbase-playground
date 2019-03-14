FROM node:10.10.0-slim

WORKDIR /src

COPY wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh

COPY app.js package.json yarn.lock ./

RUN yarn install

CMD node app.js