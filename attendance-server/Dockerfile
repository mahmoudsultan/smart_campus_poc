FROM python:3

MAINTAINER mohamedmahmoud

ENV APP_ROOT /attendance-server

WORKDIR ${APP_ROOT}

RUN pip install -r requirements.txt

CMD [ "python", "./server/server.py" ]