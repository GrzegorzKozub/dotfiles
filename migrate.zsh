#!/usr/bin/env zsh

set -o verbose

# remove ruby

[[ -d $XDG_DATA_HOME/gem ]] && rm -rf $XDG_DATA_HOME/gem

