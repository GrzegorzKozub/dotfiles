#!/usr/bin/env zsh

set -e -o verbose

# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# env

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# dirs

[[ -d ${XDG_CONFIG_HOME:-~/.config} ]] || mkdir -p ${XDG_CONFIG_HOME:-~/.config}
[[ -d ${XDG_CACHE_HOME:-~/.cache} ]] || mkdir -p ${XDG_CACHE_HOME:-~/.cache}
[[ -d ${XDG_DATA_HOME:-~/.local/share} ]] || mkdir -p ${XDG_DATA_HOME:-~/.local/share}

# zsh

export ZDOTDIR=${XDG_CONFIG_HOME:-~/.config}/zsh

[[ -d ${XDG_DATA_HOME:-~/.local/share}/zinit ]] && rm -rf ${XDG_DATA_HOME:-~/.local/share}/zinit
mkdir -p ${XDG_DATA_HOME:-~/.local/share}/zinit
git clone https://github.com/zdharma/zinit.git ${XDG_DATA_HOME:-~/.local/share}/zinit/bin
zsh -c "source ${XDG_CONFIG_HOME:-~/.config}/zsh/.zshrc && exit"

# tmux

[[ -d ${XDG_DATA_HOME:-~/.local/share}/tmux ]] && rm -rf ${XDG_DATA_HOME:-~/.local/share}/tmux
mkdir -p ${XDG_DATA_HOME:-~/.local/share}/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ${XDG_DATA_HOME:-~/.local/share}/tmux/plugins/tpm
tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf new-session -d
${XDG_DATA_HOME:-~/.local/share}/tmux/plugins/tpm/bindings/install_plugins
tmux kill-server

# shared

. `dirname $0`/shared.zsh

# node

export NG_CLI_ANALYTICS=ci
export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm

npm install --global \
  @angular/cli \
  autocannon \
  create-react-app \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  rimraf \
  typescript \
  typescript-formatter

# vim and neovim

nvim --headless +PlugInstall +qall
nvim --headless +GoInstallBinaries +qall

# vscode

for EXTENSION in \
  JakeBecker.elixir-ls \
  arjun.swagger-viewer \
  alexkrechik.cucumberautocomplete \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  esbenp.prettier-vscode \
  kddejong.vscode-cfn-lint \
  ms-azuretools.vscode-docker \
  ms-python.python \
  ms-toolsai.jupyter \
  ms-vscode.go \
  ms-vscode.vscode-typescript-tslint-plugin \
  pkief.material-icon-theme \
  redhat.vscode-yaml \
  sainnhe.forest-night \
  sainnhe.gruvbox-material
do
  code --install-extension $EXTENSION --force
done

# cleanup

unset LINUX MAC

