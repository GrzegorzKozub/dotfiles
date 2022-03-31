#!/usr/bin/env zsh

set -e -o verbose

# repo

git update-index --assume-unchanged mysql/.mysql/workbench/connections.xml
git update-index --assume-unchanged mysql/.mysql/workbench/wb_options.xml

# links

stow --dir=`dirname $0` --target=$HOME --stow \
  mysql

