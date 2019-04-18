#!/bin/sh
set -e

bundle install --without deploy production

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

exec bundle exec "$@"
