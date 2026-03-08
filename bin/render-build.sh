#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
# db:migrate は Render の build 時に DB が未起動の場合があるため、startCommand に移動します。
