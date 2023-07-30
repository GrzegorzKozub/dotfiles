#!/usr/bin/env bash

if [[ $(grep 'open' /proc/acpi/button/lid/LID0/state) ]]; then
  hyprctl keyword monitor 'eDP-1, preferred, auto, 2'
  hyprctl dispatch exec 'pkill hyprpaper; hyprpaper'
  hyprctl dispatch exec waybar
else
  hyprctl keyword monitor 'eDP-1, disable'
fi

