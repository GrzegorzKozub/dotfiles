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

# dotnet

# dotnet tool install --global dotnet-counters
# dotnet tool install --global dotnet-dump
# dotnet tool install --global dotnet-format
# dotnet tool install --global dotnet-outdated
# dotnet tool install --global dotnet-trace

# elixir

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# go

export GOPATH=${XDG_DATA_HOME:-~/.local/share}/go

for PACKAGE_FOR_VSCODE in \
  github.com/acroca/go-symbols \
  github.com/cweill/gotests/... \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/fatih/gomodifytags \
  github.com/go-delve/delve/cmd/dlv \
  github.com/godoctor/godoctor \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/josharian/impl \
  github.com/mdempsky/gocode \
  github.com/ramya-rao-a/go-outline \
  github.com/rogpeppe/godef \
  github.com/stamblerre/gocode \
  github.com/uudashr/gopkgs/cmd/gopkgs \
  golang.org/x/lint/golint \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/gorename \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/gopls
do
  echo $PACKAGE_FOR_VSCODE
  go get -u $PACKAGE_FOR_VSCODE
done

for PACKAGE_FOR_VIM in \
  github.com/fatih/motion \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  github.com/jstemmer/gotags \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/koron/iferr \
  github.com/zmb3/gogetdoc \
  honnef.co/go/tools/cmd/keyify
do
  echo $PACKAGE_FOR_VIM
  go get -u $PACKAGE_FOR_VIM
done

# node

export NG_CLI_ANALYTICS=ci
export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm

npm install --global \
  @angular/cli \
  create-react-app \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  pm2 \
  rimraf \
  typescript \
  typescript-formatter

# python

[[ $MAC ]] && alias pip='pip3'

pip install --user \
  awscli \
  docker-compose \
  lastversion \
  pynvim

# pip install --user \
#   awsebcli

pip install --user --pre \
  vim-vint

# ruby

gem install --user-install \
  neovim

# vim and neovim

nvim --headless +PlugInstall +qall

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

# cleanup

unset LINUX MAC

