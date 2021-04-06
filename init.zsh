#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

git submodule update --init
git submodule foreach --recursive git checkout master

popd

# env

export XDG_CONFIG_HOME=~/.config

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}

# links

stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
  git \
  iex \
  lf \
  mpv \
  ripgrep \
  tmux \
  vim \
  zsh

stow --dir=`dirname $0` --target=$HOME --stow \
  zprofile

[[ -d ${XDG_CONFIG_HOME:-~/.config}/nvim ]] && rm ${XDG_CONFIG_HOME:-~/.config}/nvim
ln -s $(dirname $(realpath $0))/vim/vim ${XDG_CONFIG_HOME:-~/.config}/nvim

stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
  alacritty \
  chrome \
  chromium \
  environment \
  flameshot \
  keepass \
  vscode

stow --dir=`dirname $0` --target=$HOME --stow \
  imwheel

