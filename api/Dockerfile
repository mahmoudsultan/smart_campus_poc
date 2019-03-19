FROM ruby:2.5.3

MAINTAINER mohamedmahmoud

ENV APP_ROOT /app
ENV BUNDLE_PATH /usr/local/bundle

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

WORKDIR $APP_ROOT
ADD . $APP_ROOT

RUN gem update bundler && \
    bundle install

# WORKDIR /system_api/

# # Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]