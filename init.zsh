#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

git submodule update --init
git submodule foreach --recursive git checkout master

git update-index --assume-unchanged btop/btop.conf

popd

# env

export XDG_CONFIG_HOME=~/.config

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}

# links

stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
  alacritty \
  environment \
  flameshot \
  git \
  iex \
  keepass \
  kitty \
  lf \
  mpv \
  npm \
  nvim \
  ripgrep \
  tmux \
  vscode \
  zsh

stow --dir=`dirname $0` --target=$HOME --stow \
  zprofile

[[ -d ${XDG_CONFIG_HOME:-~/.config}/btop ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}/btop
stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config}/btop --stow btop

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
    redshift

  # stow --dir=`dirname $0` --target=$HOME --stow \
    # imwheel

fi

if [[ $HOST = 'drifter' ]]; then
  ln -sf $(dirname $(realpath $0))/flags/brave-flags.intel-x11.conf ${XDG_CONFIG_HOME:-~/.config}/brave-flags.conf
  ln -sf $(dirname $(realpath $0))/flags/code-flags.intel-wayland.conf ${XDG_CONFIG_HOME:-~/.config}/code-flags.conf
fi

if [[ $HOST = 'player' ]]; then
  ln -sf $(dirname $(realpath $0))/flags/brave-flags.nvidia-x11.conf ${XDG_CONFIG_HOME:-~/.config}/brave-flags.conf
  ln -sf $(dirname $(realpath $0))/flags/code-flags.nvidia-x11.conf ${XDG_CONFIG_HOME:-~/.config}/code-flags.conf
fi

if [[ $HOST = 'worker' ]]; then
  ln -sf $(dirname $(realpath $0))/flags/brave-flags.nvidia-x11.conf ${XDG_CONFIG_HOME:-~/.config}/brave-flags.conf
  ln -sf $(dirname $(realpath $0))/flags/code-flags.nvidia-x11.conf ${XDG_CONFIG_HOME:-~/.config}/code-flags.conf
fi

