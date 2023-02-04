#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ $HOST = 'player' ]] || exit 1

# env

export XDG_CONFIG_HOME=~/.config

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}

# links

stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
  gamemode \
  mangohud

