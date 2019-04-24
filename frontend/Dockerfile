FROM node:10.7-alpine

ENV APP_ROOT /frontend

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
COPY package.json ${APP_ROOT}

RUN npm install

ADD . ${APP_ROOT}

ENV HOST 0.0.0.0