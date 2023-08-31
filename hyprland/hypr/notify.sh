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
  [[ $1 = 'up' ]] && local step='+5%' || local step='5%-' # else down
  local bright=$(brightnessctl set $step)
  dunstify \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:50 \
    -t 1000 \
    "$bright"

# brightnessctl set +50% | grep 'Current brightness' | sed -e 's/.*\((.*)\)/{\1}/'


}

[[ $1 = 'mute' ]] && mute
[[ $1 = 'volume' ]] && volume $2
[[ $1 = 'device' ]] && device $2
[[ $1 = 'brightness' ]] && brightness $2

