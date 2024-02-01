#!/usr/bin/env zsh

set -e -o verbose

# bat

bat cache --build

# elixir

export HEX_HOME=$XDG_CACHE_HOME/hex
export MIX_HOME=$XDG_DATA_HOME/mix

[[ -d $HEX_HOME ]] && rm -rf $HEX_HOME
[[ -d $MIX_HOME ]] && rm -rf $MIX_HOME
[[ -d $XDG_CACHE_HOME/rebar3 ]] && rm -rf $XDG_CACHE_HOME/rebar3

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# python

pip install --user --upgrade --break-system-packages \
  wheel

pip install --user --upgrade --break-system-packages \
  awscli-local \
  cfn-lint \
  lastversion \
  pynvim

# ruby

[[ -d $XDG_DATA_HOME/gem ]] && rm -rf $XDG_DATA_HOME/gem

gem install --user-install \
  neovim

# rust

export CARGO_HOME=$XDG_DATA_HOME/cargo

cargo install \
  jwt-cli

# vscode

for EXTENSION in \
  JakeBecker.elixir-ls \
  antfu.icons-carbon \
  CucumberOpen.cucumber-official \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  esbenp.prettier-vscode \
  golang.Go \
  kddejong.vscode-cfn-lint \
  ms-azuretools.vscode-docker \
  ms-dotnettools.csdevkit \
  ms-dotnettools.csharp \
  ms-dotnettools.vscode-dotnet-runtime \
  ms-python.black-formatter \
  ms-python.isort \
  ms-python.python \
  ms-python.pylint \
  ms-python.vscode-pylance \
  pkief.material-icon-theme \
  redhat.vscode-yaml \
  sainnhe.gruvbox-material \
  streetsidesoftware.code-spell-checker \
  sumneko.lua
do
  code --install-extension $EXTENSION --force
done

for PACKAGE in \
  github.com/cweill/gotests/gotests \
  github.com/fatih/gomodifytags \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  github.com/josharian/impl \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/go-delve/delve/cmd/dlv \
  honnef.co/go/tools/cmd/staticcheck \
  golang.org/x/tools/gopls
do
  go install -v $PACKAGE@latest
done

