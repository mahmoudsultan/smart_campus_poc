FROM ruby:2.5.3

MAINTAINER mohamedmahmoud

<<<<<<< HEAD
=======
ENV APP_ROOT /api
ENV BUNDLE_PATH ${APP_ROOT}/bundle
>>>>>>> master

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

ENV APP_ROOT /api
ENV BUNDLE_PATH $APP_ROOT/bundle

WORKDIR $APP_ROOT

<<<<<<< HEAD
# ADD . $APP_ROOT

ENV PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${PATH}"

ENV GEM_PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${GEM_PATH}"

RUN echo $PATH
RUN echo $GEM_PATH

# RUN gem update bundler && \
#     bundle install 

# RUN PATH="$PATH:$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin"

=======
ENV PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${PATH}"

ENV GEM_PATH="$BUNDLE_PATH:$BUNDLE_PATH/bin:$BUNDLE_PATH/gems/bin:${GEM_PATH}"

RUN gem update bundler

>>>>>>> master
CMD rails s -b 0.0.0.0