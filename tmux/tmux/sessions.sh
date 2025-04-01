#!/usr/bin/env bash

# TODO: icons, current, --header-lines

QUERY="
  tmux list-sessions \
    -F '#{session_name} #{t/p:session_created} #{session_windows} #{session_attached} #{session_path}' | \
  column --output-separator ' ' --table --table-right 1,3,4 | \
  sort --key 1 --reverse
"

KEYS="$(echo -e "\e[35m<Enter>\e[0m \e[37mSwitch\e[0m · \e[35m<C-k>\e[0m \e[37mKill\e[0m · \e[35m<C-n>\e[0m \e[37mNew\e[0m")"

LIST=$(eval "$QUERY") && LIST=${//$HOME/\~}

SELECTED=$(
  echo -e "$LIST" |
  fzf --tmux center,33%,33% \
    --layout default --list-border rounded --input-border rounded \
    --ansi --color header:bright-black \
    --header "$KEYS" --header-first \
    --bind "ctrl-k:execute-silent(tmux kill-session -t {1})+reload($QUERY)" \
    --bind "ctrl-n:execute-silent(tmux new-session -d)+reload($QUERY)" \
    --accept-nth 1
)

EXIT=$? && [ $EXIT == 0 ] && tmux switch-client -t "$SELECTED" || exit 0

