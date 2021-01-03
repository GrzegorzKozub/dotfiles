#!/usr/bin/env zsh

set -e -o verbose

# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# env

export XDG_CONFIG_HOME=~/.config

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}

# links

if [[ $LINUX ]]; then

  stow --dir=`dirname $0` --target=${XDG_CONFIG_HOME:-~/.config} --stow \
    azuredatastudio

fi

# cleanup

unset LINUX MAC

