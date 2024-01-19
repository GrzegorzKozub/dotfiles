#!/usr/bin/env bash

[[ $HOST = 'drifter' || $HOST = 'player' ]] && echo 15
[[ $HOST = 'worker' ]] && echo 21

