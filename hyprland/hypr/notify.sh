#!/usr/bin/env bash

volume() {
  ~/code/arch/audio.zsh $1
  local vol=$(~/code/arch/audio.zsh)
  if (( $vol < 33 )); then local icon="󰕿"
  elif (( $vol > 66 )); then local icon="󰕾"
  else local icon="󰖀"; fi
  dunstify \
    -h string:x-canonical-private-synchronous:audio \
    -h int:value:$vol \
    -t 1000 \
    "$icon $vol%"
}

[[ $1 = 'volume' ]] && volume $2

