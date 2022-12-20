#!/usr/bin/env zsh

set -e -o verbose

# switch nvim between vim and lua config

if [[ -f ~/.config/nvim/init.lua ]]; then
  rm ~/.config/nvim
  ln -s $(dirname $(realpath $0))/vim/vim ~/.config/nvim
else
  rm ~/.config/nvim
  stow --dir=`dirname $0` --target=~/.config --stow nvim
fi

