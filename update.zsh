#!/usr/bin/env zsh

set -o verbose

# zsh

declare -A ZINIT
export ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit
export ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

source $ZINIT[HOME_DIR]/bin/zinit.zsh

zinit update --all --quiet

# tmux

for plugin in $XDG_DATA_HOME/tmux/plugins/*; do
  $XDG_DATA_HOME/tmux/plugins/tpm/scripts/update_plugin.sh \
    --shell-echo \
    $(echo $plugin | sed 's/^.*\///')
done

# elixir, go and ruby

. `dirname $0`/clean.zsh

# node

npm update --global

# python

pip list --outdated --format=freeze | \
  cut -d = -f 1 | \
  xargs -n1 pip install --upgrade

# vim and neovim

nvim --headless +PlugUpdate +qall

# vscode

code --list-extensions | \
  xargs -n1 code --force --install-extension

