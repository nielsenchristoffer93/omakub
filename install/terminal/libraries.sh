#!/bin/bash

sudo apt install -y \
  build-essential pkg-config autoconf bison clang rustc pipx \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libncurses-dev libffi-dev libgdbm-dev libjemalloc2 \
  libvips-dev imagemagick libmagickwand-dev mupdf mupdf-tools \
  redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common
