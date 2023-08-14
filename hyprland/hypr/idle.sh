#!/usr/bin/env bash

swayidle -w \
  timeout 60 'brightnessctl set 10% --save' resume 'brightnessctl --restore' \
  timeout 300 'hyprctl dispatch dpms off && swaylock' resume 'hyprctl dispatch dpms on' \
  timeout 600 'systemctl suspend' \
  before-sleep 'pidof swaylock || swaylock'

