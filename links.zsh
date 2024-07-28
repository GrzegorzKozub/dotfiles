#!/usr/bin/env zsh

set -e -o verbose

# links

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  bat \
  btop \
  cava \
  dust \
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
  teams-for-linux \
  tmux \
  vscode \
  yazi \
  yt-dlp \
  zsh

  # alacritty flameshot foot gdu iex zellij

# if [[ $HOST = 'player' ]]; then
#
#   stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
#     redshift
#
# fi

stow --dir=`dirname $0` --target=$HOME --stow \
  zprofile

  # imwheel

DIR=$(dirname $(realpath $0))

[[ -d $XDG_CONFIG_HOME/environment.d ]] || mkdir -p $XDG_CONFIG_HOME/environment.d
ln -sf $DIR/environment/environment.d/10-common.conf $XDG_CONFIG_HOME/environment.d/10-common.conf

if [[ $HOST = 'drifter' ]]; then

  ln -sf $DIR/environment/environment.d/20-intel.conf $XDG_CONFIG_HOME/environment.d/20-intel.conf

  ln -sf $DIR/flags/brave-flags.intel-wayland.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.intel-wayland.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'player' ]]; then

  ln -sf $DIR/environment/environment.d/20-nvidia.conf $XDG_CONFIG_HOME/environment.d/20-nvidia.conf

  ln -sf $DIR/flags/brave-flags.nvidia-wayland.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.nvidia-wayland.conf $XDG_CONFIG_HOME/code-flags.conf

fi

if [[ $HOST = 'worker' ]]; then

  ln -sf $DIR/environment/environment.d/20-amd.conf $XDG_CONFIG_HOME/environment.d/20-amd.conf

  ln -sf $DIR/flags/brave-flags.amd-wayland.conf $XDG_CONFIG_HOME/brave-flags.conf
  ln -sf $DIR/flags/code-flags.amd-wayland.conf $XDG_CONFIG_HOME/code-flags.conf

fi

