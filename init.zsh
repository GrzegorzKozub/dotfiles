#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

git submodule update --init
git submodule foreach --recursive git checkout master

git update-index --assume-unchanged \
  keepass.arch/keepassxc/keepassxc.ini \
  keepass.mac/KeePassXC/keepassxc.ini

popd

# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# env

export XDG_CONFIG_HOME=~/.config

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}

[[ -d ~/code/backups ]] || mkdir ~/code/backups

# links

stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
  git \
  iex \
  ranger \
  ripgrep \
  tmux \
  vim \
  zsh

[[ -d ${XDG_CONFIG_HOME:-~/.config}/nvim ]] && rm ${XDG_CONFIG_HOME:-~/.config}/nvim
ln -s $(dirname $(realpath $0))/vim/vim ${XDG_CONFIG_HOME:-~/.config}/nvim

if [[ $LINUX ]]; then

  stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
    alacritty.arch \
    chrome \
    environment.arch \
    flameshot \
    keepass.arch \
    vscode

  stow --dir=`dirname $0` --target=$HOME --stow \
    imwheel

fi

if [[ $MAC ]]; then

  stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
    alacritty.mac

  stow --dir=`dirname $0` --target=$HOME/Library/LaunchAgents --stow \
    environment.mac

  launchctl unload ~/Library/LaunchAgents/environment.plist
  launchctl load ~/Library/LaunchAgents/environment.plist

  launchctl unload ~/Library/LaunchAgents/key-mapping.plist
  launchctl load ~/Library/LaunchAgents/key-mapping.plist

  stow --dir=`dirname $0` --target=$HOME/Library/Application\ Support --stow \
    keepass.mac \
    vscode

fi

# cleanup

unset LINUX MAC

