#!/bin/bash
set -e

echo "### Starting rails server... ###"
# Remove a potentially pre-existing server.pid for Rails.
if [ -f /home/instabug-user/instabug-task/tmp/pids/server.pid ]; then
  rm /home/instabug-user/instabug-task/tmp/pids/server.pid
fi

bundle install
rails db:migrate
yarn install
exec "$@"
