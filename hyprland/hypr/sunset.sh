#!/usr/bin/env bash

if [[ $(pidof wlsunset) ]]; then
  killall -9 wlsunset
else
  wlsunset -l 52.26 -L 21.01
fi

