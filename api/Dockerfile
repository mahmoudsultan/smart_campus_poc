FROM ruby:2.5.3

MAINTAINER mohamedmahmoud

ENV APP_ROOT /api
ENV BUNDLE_PATH ${APP_ROOT}/bundle

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

WORKDIR $APP_ROOT
ADD . $APP_ROOT

ENV PATH="${BUNDLE_PATH}/bin:${BUNDLE_PATH}/bin/gem:${PATH}"

RUN echo ${PATH}

RUN gem update bundler

# CMD ["rails", "server", "-b", "0.0.0.0"]