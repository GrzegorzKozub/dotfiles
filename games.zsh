#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ $HOST = 'player' ]] || exit 1

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# dirs

[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME

# links

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  gamemode \
  mangohud

