#!/usr/bin/env zsh

set -o verbose

# go

[[ -d $XDG_CACHE_HOME/go-build ]] && rm -rf $XDG_CACHE_HOME/go-build
[[ -d $XDG_DATA_HOME/go ]] && sudo rm -rf $XDG_DATA_HOME/go

for PACKAGE in \
  github.com/cweill/gotests/gotests \
  github.com/fatih/gomodifytags \
  github.com/go-delve/delve/cmd/dlv \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/josharian/impl \
  golang.org/x/tools/gopls \
  honnef.co/go/tools/cmd/staticcheck
do
  go install -v $PACKAGE@latest
done
