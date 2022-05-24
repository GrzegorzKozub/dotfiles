#!/usr/bin/env zsh

if [[ $1 == '--raise-volume' ]]; then

  pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print substr($5, 1, length($5)-1)}'

fi
