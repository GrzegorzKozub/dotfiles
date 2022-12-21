#!/usr/bin/env zsh

set -e -o verbose

# switch nvim between vim and lua config

CONFIG=${XDG_CONFIG_HOME:-~/.config}

if [[ -f $CONFIG/nvim/init.lua ]]; then
  rm $CONFIG/nvim
  ln -s $(dirname $(realpath $0))/vim/vim $CONFIG/nvim
else
  rm ~/.config/nvim
  stow --dir=`dirname $0` --target=$CONFIG --stow nvim
fi



