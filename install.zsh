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
  pm2 \
  rimraf \
  typescript \
  typescript-formatter

# vim and neovim

nvim --headless +PlugInstall +qall
nvim --headless +GoInstallBinaries +qall

# vscode

for EXTENSION in \
  JakeBecker.elixir-ls \
  alexkrechik.cucumberautocomplete \
  aws-scripting-guy.cform \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  esbenp.prettier-vscode \
  ms-azuretools.vscode-docker \
  ms-vscode.go \
  ms-vscode.vscode-typescript-tslint-plugin \
  pkief.material-icon-theme \
  redhat.vscode-yaml \
  sainnhe.gruvbox-material
do
  code --install-extension $EXTENSION --force
done

export GOPATH=${XDG_DATA_HOME:-~/.local/share}/go

for PACKAGE in \
  github.com/mdempsky/gocode \
  github.com/uudashr/gopkgs/v2/cmd/gopkgs \
  github.com/ramya-rao-a/go-outline \
  github.com/acroca/go-symbols \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/cmd/gorename \
  github.com/cweill/gotests/... \
  github.com/fatih/gomodifytags \
  github.com/josharian/impl \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/godoctor/godoctor \
  github.com/go-delve/delve/cmd/dlv \
  github.com/stamblerre/gocode \
  github.com/rogpeppe/godef \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/lint/golint \
  golang.org/x/tools/gopls
do
  echo $PACKAGE
  go get -v $PACKAGE
done

# cleanup

unset LINUX MAC

