#!/usr/bin/env zsh

set -o verbose

# elixir

[[ -d $XDG_CACHE_HOME/hex ]] && rm -rf $XDG_CACHE_HOME/hex
[[ -d $XDG_CONFIG_HOME/iex ]] && rm -rf $XDG_CONFIG_HOME/iex
[[ -d $XDG_DATA_HOME/mix ]] && rm -rf $XDG_DATA_HOME/mix

# go

[[ -d $XDG_CACHE_HOME/go-build ]] && rm -rf $XDG_CACHE_HOME/go-build

# node

rm -rf $XDG_CACHE_HOME/npm
npm uninstall --global js-beautify typescript-formatter

# ruby

[[ -d $XDG_DATA_HOME/gem ]] && rm -rf $XDG_DATA_HOME/gem

# vscode

code --uninstall-extension JakeBecker.elixir-ls

for EXTENSION in \
  ms-python.debugpy \
  rust-lang.rust-analyzer \
  tamasfe.even-better-toml
do
  code --install-extension $EXTENSION
done

