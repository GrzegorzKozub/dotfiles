#!/usr/bin/env zsh

set -o verbose

[[ -f `dirname $0`/zsh/zsh/.env ]] &&
  mv `dirname $0`/zsh/zsh/.env `dirname $0`/zsh/zsh/.zshenv

