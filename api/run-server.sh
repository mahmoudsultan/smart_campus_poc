#!/bin/bash
gem update bundler
bundle check || bundle install

bundle exec rails s -b 0.0.0.0