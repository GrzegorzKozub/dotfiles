#!/usr/bin/env bash

# https://github.com/sainnhe/tmux-fzf
# https://github.com/cutbypham/tmux-fzf-session-switch
# https://github.com/joshmedeski/t-smart-tmux-session-manager
# https://github.com/27medkamal/tmux-session-wizard
# https://github.com/2KAbhishek/tmux-tea

SESSIONS=$(
  tmux list-sessions \
    -F "\e[37m#{session_name}\e[0m #{t/p:session_created} #{session_windows} #{session_attached} \e[36m#{session_path}\e[0m"
)
SESSIONS=${SESSIONS//$HOME/\~}
echo -e "$SESSIONS" | fzf --ansi --height 100% --layout default
