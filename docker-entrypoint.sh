#!/bin/bash

set -e

bundle check || bundle install

rails db:setup

exec "$@"
