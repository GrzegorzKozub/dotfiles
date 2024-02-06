#!/usr/bin/env zsh

set -o verbose

# go

[[ -d $XDG_CACHE_HOME/go-build ]] && rm -rf $XDG_CACHE_HOME/go-build

# ruby

[[ -d $XDG_DATA_HOME/gem ]] && rm -rf $XDG_DATA_HOME/gem

