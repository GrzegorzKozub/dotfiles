#!/usr/bin/env zsh

set -o verbose

# node

rm -rf $XDG_CACHE_HOME/npm

fnm install --latest
fnm use default

npm install --global \
  autocannon \
  eslint \
  express-generator \
  neovim \
  rimraf \
  typescript

