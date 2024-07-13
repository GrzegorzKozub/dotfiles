#!/usr/bin/env zsh

set -e -o verbose

# links

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  bat \
  cava \
  dust \
  environment \
  flameshot \
  fsh \
  git \
  keepass \
  kitty \
  lf \
  mpv \
  npm \
  nvim \
  ripgrep \
  satty \
  silicon \
  tmux \
  vscode \
  yazi \
  yt-dlp \
  zsh

  # alacritty foot gdu iex zellij

# if [[ $HOST = 'player' ]]; then
#
#   stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
#     redshift
#
# fi

stow --dir=`dirname $0` --target=$HOME --stow \
  zprofile

  # imwheel

[[ -d $XDG_CONFIG_HOME/btop ]] || mkdir -p $XDG_CONFIG_HOME/btop
stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME/btop --stow btop

DIR=$(dirname $(realpath $0))

if [[ $HOST = 'drifter' ]]; then

  ln -sf $DIR/flags/brave-flags.intel-x11.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.intel-x11.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'player' ]]; then

  ln -sf $DIR/flags/brave-flags.nvidia-x11.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.nvidia-x11.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'worker' ]]; then

  ln -sf $DIR/flags/brave-flags.amd-wayland.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.amd-wayland.conf $XDG_CONFIG_HOME/code-flags.conf

fi

