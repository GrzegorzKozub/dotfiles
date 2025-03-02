#!/usr/bin/env bash

FILE=$(mktemp)
tmux capture-pane -p -S -10000 > $FILE
tmux new-window -n scrollback "nvim + $FILE"

