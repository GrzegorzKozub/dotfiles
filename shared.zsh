#!/usr/bin/env zsh

set -e -o verbose

# elixir

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex
export MIX_HOME=${XDG_DATA_HOME:-~/.local/share}/mix

[[ -d $HEX_HOME ]] && rm -rf $HEX_HOME
[[ -d $MIX_HOME ]] && rm -rf $MIX_HOME
[[ -d $XDG_CACHE_HOME/rebar3 ]] && rm -rf $XDG_CACHE_HOME/rebar3

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# python

pip install --user --upgrade \
  wheel

pip install --user --upgrade \
  autopep8 \
  awscli-local \
  cfn-lint \
  docker-compose \
  lastversion \
  locust \
  pylint \
  pynvim \
  yamllint

# ruby

[[ -d ${XDG_DATA_HOME:-~/.local/share}/gem ]] && rm -rf ${XDG_DATA_HOME:-~/.local/share}/gem

gem install --user-install \
  neovim

# rust

export CARGO_HOME=${XDG_DATA_HOME:-~/.local/share}/cargo

cargo install \
  jwt-cli

# vscode

for PACKAGE in \
  github.com/cweill/gotests/gotests \
  github.com/fatih/gomodifytags \
  github.com/josharian/impl \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/go-delve/delve/cmd/dlv \
  honnef.co/go/tools/cmd/staticcheck \
  golang.org/x/tools/gopls
do
  go install -v $PACKAGE@latest
done

