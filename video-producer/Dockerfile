FROM python:3.7

MAINTAINER mohamedmahmoud

ENV APP_ROOT /video-producer

WORKDIR ${APP_ROOT}

COPY test_video.mp4 ${APP_ROOT}

ADD requirements.txt ${APP_ROOT}

RUN pip install -r requirements.txt

# CMD [ "python", "./server/server.py" ]