#!/usr/bin/env bash

[[ $HOST = 'drifter' || $HOST = 'player' ]] && echo 13
[[ $HOST = 'worker' ]] && echo 21

