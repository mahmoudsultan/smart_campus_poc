FROM node:10.7-alpine

MAINTAINER mohamedmahmoud

ENV APP_ROOT /frontend

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
COPY package.json ${APP_ROOT}

RUN npm cache clean --force

RUN npm install

ADD . ${APP_ROOT}

ENV HOST 0.0.0.0
