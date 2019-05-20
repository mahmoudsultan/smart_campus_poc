FROM ruby:2.5.3

MAINTAINER mohamedmahmoud

ENV APP_ROOT /api
ENV BUNDLE_PATH ${APP_ROOT}/bundle

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

WORKDIR $APP_ROOT

ENV PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${PATH}"

ENV GEM_PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${GEM_PATH}"

RUN gem update bundler

CMD rails s -b 0.0.0.0