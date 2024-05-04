#!/usr/bin/env zsh

set -o verbose

# neovim

nvim --headless -c 'Lazy! build LuaSnip' -c 'quitall'

# python

rm -rf ~/.cache/pip

rm -rf ~/.local/bin
rm -rf ~/.local/include
rm -rf ~/.local/lib

# cargo-update

cargo install \
  cargo-update \
  --force --features vendored-libgit2 --features vendored-openssl
