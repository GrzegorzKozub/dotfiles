#!/usr/bin/env bash

mute() {
  local muted=$(~/code/arch/audio.zsh mute)
  [[ $muted = 'yes' ]] && local icon='󰖁' || local icon='󰕾'
  dunstify \
    -h string:x-canonical-private-synchronous:mute \
    -t 1000 \
    "$icon"
}

volume() {
  local vol=$(~/code/arch/audio.zsh $1)
  if (( $vol < 33 )); then local icon='󰕿'
  elif (( $vol > 66 )); then local icon='󰕾'
  else local icon='󰖀'; fi
  dunstify \
    -h string:x-canonical-private-synchronous:volume \
    -h int:value:$vol \
    -t 1000 \
    "$icon $vol%"
}

device() {
  local name=$(~/code/arch/audio.zsh $1)
  [[ $1 = 'sink' ]] && local icon='󰓃' || local icon='󰍬' # else source
  dunstify \
    -h string:x-canonical-private-synchronous:device \
    -t 1000 \
    "$icon $name"
}

brightness() {
  local brightness=$(~/code/arch/brightness.zsh $1)
  dunstify \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:$brightness \
    -t 1000 \
    "󰌵 $brightness%"
}

[[ $1 = 'mute' ]] && mute
[[ $1 = 'volume' ]] && volume $2
[[ $1 = 'device' ]] && device $2
[[ $1 = 'brightness' ]] && brightness $2

