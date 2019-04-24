FROM node:10.7-alpine
ENV APP_ROOT /frontend
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
ADD . ${APP_ROOT}
RUN apk add inotify-tools
RUN npm install
ENV HOST 0.0.0.0