#!/usr/bin/env zsh

set -o verbose

# env

if [[ -f ./zsh/zsh/env.zsh ]]; then
  mv ./zsh/zsh/env.zsh ./zsh/zsh/.env
  sed -i -e 's/^export //' ./zsh/zsh/.env
fi

# fetch

rm -rf ~/.cache/zsh

