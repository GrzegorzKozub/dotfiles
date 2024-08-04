#!/usr/bin/env zsh

set -e -o verbose

# repo

pushd `dirname $0`

for ITEM (
  'conversion/page_setup.py'
  'dynamic.pickle.json'
  'global.py.json'
  'gui.json'
  'gui.py.json'
)
  git update-index --assume-unchanged calibre/calibre/$ITEM

popd

# links

stow --dir=`dirname $0` --target=$XDG_CONFIG_HOME --stow \
  calibre

