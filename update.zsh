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

# shared

. `dirname $0`/shared.zsh

# node

npm update --global

# ruby

gem update

# vim and neovim

nvim --headless +PlugUpdate +qall
nvim --headless +GoUpdateBinaries +qall

# vscode

code --list-extensions | \
  xargs -n1 code --force --install-extension

go get -u -v all

