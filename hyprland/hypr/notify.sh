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

device() {
  local name=$(~/code/arch/audio.zsh $1)
  dunstify \
    -h string:x-canonical-private-synchronous:audio \
    -t 1000 \
    "$2 $name"
}

# brightness() { string:x-canonical-private-synchronous:brightness }

[[ $1 = 'volume' ]] && volume $2
[[ $1 = 'sink' ]] && device $1 '󰓃'
[[ $1 = 'source' ]] && device $1 '󰍬'
[[ $1 = 'brightness' ]] && brightness $2

