#!/usr/bin/env zsh

set -e -o verbose

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

git clone https://github.com/zdharma-continuum/zinit.git ${XDG_DATA_HOME:-~/.local/share}/zinit/bin

export TMUX=1
zsh -c "source ${XDG_CONFIG_HOME:-~/.config}/zsh/.zshrc && exit"
unset TMUX

# tmux

[[ -d ${XDG_DATA_HOME:-~/.local/share}/tmux ]] && rm -rf ${XDG_DATA_HOME:-~/.local/share}/tmux
mkdir -p ${XDG_DATA_HOME:-~/.local/share}/tmux/plugins

git clone https://github.com/tmux-plugins/tpm ${XDG_DATA_HOME:-~/.local/share}/tmux/plugins/tpm

tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf new-session -d
${XDG_DATA_HOME:-~/.local/share}/tmux/plugins/tpm/bindings/install_plugins
tmux kill-server

# gnupg

export GNUPGHOME=${XDG_DATA_HOME:-~/.local/share}/gnupg

[[ -d $GNUPGHOME ]] && rm -rf $GNUPGHOME
mkdir $GNUPGHOME && chmod 700 $GNUPGHOME

gpg --batch --generate-key <<EOF
Key-Type: 1
Key-Length: 3072
Name-Real: Grzegorz Kozub
Name-Email: grzegorz.kozub@gmail.com
Passphrase: passphrase
EOF

# pass

export PASSWORD_STORE_DIR=${XDG_DATA_HOME:-~/.local/share}/pass

pass init grzegorz.kozub@gmail.com

# shared

. `dirname $0`/shared.zsh

# node

export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME:-~/.config}/npm/npmrc

export NG_CLI_ANALYTICS=ci

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

# neovim

# nvim --headless +PlugInstall +qall
nvim --headless +GoInstallBinaries +qall

# vscode

for EXTENSION in \
  JakeBecker.elixir-ls \
  alefragnani.Bookmarks \
  alexkrechik.cucumberautocomplete \
  antfu.icons-carbon \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  esbenp.prettier-vscode \
  golang.Go \
  kddejong.vscode-cfn-lint \
  ms-azuretools.vscode-docker \
  ms-dotnettools.csharp \
  ms-python.python \
  ms-python.vscode-pylance \
  ms-vscode.hexeditor \
  pkief.material-icon-theme \
  redhat.vscode-yaml \
  sainnhe.gruvbox-material \
  streetsidesoftware.code-spell-checker
do
  code --install-extension $EXTENSION --force
done

# docker

docker run --privileged --rm tonistiigi/binfmt --install arm64
docker rmi $(docker images tonistiigi/binfmt -a -q)

docker buildx create --name builder --use

