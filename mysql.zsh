#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

git update-index --assume-unchanged mysql/.mysql/workbench/connections.xml
git update-index --assume-unchanged mysql/.mysql/workbench/wb_options.xml
git update-index --assume-unchanged mysql/.mysql/workbench/wb_state.xml

popd

# links

stow --dir=`dirname $0` --target=$HOME --stow \
  mysql

