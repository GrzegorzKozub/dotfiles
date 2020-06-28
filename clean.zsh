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

# go

export GOPATH=${XDG_DATA_HOME:-~/.local/share}/go

[[ -d $GOPATH ]] && rm -rf $GOPATH

for PACKAGE_FOR_VSCODE in \
  github.com/acroca/go-symbols \
  github.com/cweill/gotests/... \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/fatih/gomodifytags \
  github.com/go-delve/delve/cmd/dlv \
  github.com/godoctor/godoctor \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/josharian/impl \
  github.com/mdempsky/gocode \
  github.com/ramya-rao-a/go-outline \
  github.com/rogpeppe/godef \
  github.com/stamblerre/gocode \
  github.com/uudashr/gopkgs/cmd/gopkgs \
  golang.org/x/lint/golint \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/gorename \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/gopls
do
  echo $PACKAGE_FOR_VSCODE
  go get -u $PACKAGE_FOR_VSCODE
done

for PACKAGE_FOR_VIM in \
  github.com/fatih/motion \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  github.com/jstemmer/gotags \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/koron/iferr \
  github.com/zmb3/gogetdoc \
  honnef.co/go/tools/cmd/keyify
do
  echo $PACKAGE_FOR_VIM
  go get -u $PACKAGE_FOR_VIM
done

# ruby

[[ -d ~/.gem ]] && rm -rf ~/.gem

gem install --user-install \
  neovim

