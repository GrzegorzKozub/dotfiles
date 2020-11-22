#!/usr/bin/env zsh

set -e -o verbose

# elixir

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex

[[ -d $HEX_HOME ]] && rm -rf $HEX_HOME
[[ -d $XDG_CACHE_HOME/rebar3 ]] && rm -rf $XDG_CACHE_HOME/rebar3
[[ -d $XDG_DATA_HOME/mix ]] && rm -rf $XDG_DATA_HOME/mix
[[ -d ~/.mix ]] && rm -rf ~/.mix # mix does not follow $XDG_DATA_HOME anymore

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
  glances \
  ipykernel \
  lastversion \
  locust \
  pydot \
  pylint \
  pynvim \
  rope

pip install --user --pre --force \
  vim-vint

# ruby

[[ -d ~/.gem ]] && rm -rf ~/.gem

gem install --user-install \
  neovim

# vscode

export GOPATH=${XDG_DATA_HOME:-~/.local/share}/go

TMP="$(mktemp -d)"
pushd $TMP
echo 'module dotfiles' > $TMP/go.mod

for PACKAGE in \
  github.com/mdempsky/gocode \
  github.com/uudashr/gopkgs/v2/cmd/gopkgs \
  github.com/ramya-rao-a/go-outline \
  github.com/acroca/go-symbols \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/cmd/gorename \
  github.com/cweill/gotests/... \
  github.com/fatih/gomodifytags \
  github.com/josharian/impl \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/godoctor/godoctor \
  github.com/go-delve/delve/cmd/dlv \
  github.com/rogpeppe/godef \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/lint/golint \
  golang.org/x/tools/gopls
do
  go get -v $PACKAGE
done

go get -v -d github.com/stamblerre/gocode
go build -o $GOPATH/bin/gocode-gomod github.com/stamblerre/gocode

popd
rm -rf $TMP
unset TMP

