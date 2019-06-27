#!/bin/bash

rm -f /api/tmp/pids/server.pid

bundle check || bundle install

bundle exec rails s -b 0.0.0.0