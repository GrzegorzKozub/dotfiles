#!/usr/bin/env bash

swayidle -w \
  timeout 60 'brightnessctl set 0% --save' resume 'brightnessctl --restore' \
  timeout 300 'pidof swaylock || swaylock' \
  timeout 600 'systemctl suspend' \
  before-sleep 'pidof swaylock || swaylock'

