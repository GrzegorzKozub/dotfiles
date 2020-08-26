#!/usr/bin/env zsh

set -e -o verbose

# elixir

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex

[[ -d $HEX_HOME ]] && rm -rf $HEX_HOME
[[ -d $XDG_CACHE_HOME/rebar3 ]] && rm -rf $XDG_CACHE_HOME/rebar3
[[ -d $XDG_DATA_HOME/mix ]] && rm -rf $XDG_DATA_HOME/mix

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# python

[[ $MAC ]] && alias pip='pip3'

pip install --user --force \
  wheel

pip install --user --force \
  setuptools

pip install --user --force \
  autopep8 \
  awscli \
  cfn-lint \
  docker-compose \
  ipykernel \
  lastversion \
  locust \
  pydot \
  pylint \
  pynvim

pip install --user --pre --force \
  vim-vint

# ruby

[[ -d ~/.gem ]] && rm -rf ~/.gem

gem install --user-install \
  neovim

