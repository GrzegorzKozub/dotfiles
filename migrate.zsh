#!/usr/bin/env zsh

set -e -o verbose

for DIR in \
  bat \
  btop \
  cava \
  fsh \
  git \
  ghostty \
  kitty \
  mpv \
  npm \
  nushell \
  nvim \
  ripgrep \
  satty \
  silicon \
  teams-for-linux \
  tmux \
  yamllint \
  yazi \
  yt-dlp \
  zed \
  zellij \
  zsh
do
  rm -rf $XDG_CONFIG_HOME/$DIR
  stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow $DIR
done

rm -rf $XDG_CONFIG_HOME/keepassxc
stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow keepass

rm -rf $XDG_CONFIG_HOME/Code
stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow vscode

rm -rf $HOME/.zprofile
stow --dir=`dirname $0` --target=$HOME --stow zprofile

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

