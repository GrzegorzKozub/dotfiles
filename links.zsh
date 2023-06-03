#!/usr/bin/env zsh

set -e -o verbose

# links

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  environment \
  flameshot \
  fsh \
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

  # alacritty \
  # foot \

stow --dir=`dirname $0` --target=$HOME --stow \
  zprofile

[[ -d $XDG_CONFIG_HOME/btop ]] || mkdir -p $XDG_CONFIG_HOME/btop
stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME/btop --stow btop

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
    redshift

  # stow --dir=`dirname $0` --target=$HOME --stow \
  #   imwheel

fi

DIR=$(dirname $(realpath $0))

if [[ $HOST = 'drifter' ]]; then

  # xwayland
  ln -sf $DIR/flags/brave-flags.intel-x11.conf $XDG_CONFIG_HOME/brave-flags.conf

  # native wayland
  ln -sf $DIR/flags/code-flags.intel-wayland.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'player' ]]; then

  # x11
  ln -sf $DIR/flags/brave-flags.nvidia-x11.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.nvidia-x11.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'worker' ]]; then

  # xwayland
  ln -sf $DIR/flags/brave-flags.nvidia-x11.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.nvidia-x11.conf $XDG_CONFIG_HOME/code-flags.conf

fi

