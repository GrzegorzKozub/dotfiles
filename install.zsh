#!/usr/bin/env zsh

set -e -o verbose

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}

# dirs

[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME
[[ -d $XDG_CACHE_HOME ]] || mkdir -p $XDG_CACHE_HOME
[[ -d $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME

# zsh

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

[[ -d $XDG_DATA_HOME/zinit ]] && rm -rf $XDG_DATA_HOME/zinit
mkdir -p $XDG_DATA_HOME/zinit

git clone https://github.com/zdharma-continuum/zinit.git $XDG_DATA_HOME/zinit/bin

export TMUX=1
zsh -c "source $XDG_CONFIG_HOME/zsh/.zshrc && exit"
unset TMUX

# tmux

[[ -d $XDG_DATA_HOME/tmux ]] && rm -rf $XDG_DATA_HOME/tmux
mkdir -p $XDG_DATA_HOME/tmux/plugins

git clone https://github.com/tmux-plugins/tpm $XDG_DATA_HOME/tmux/plugins/tpm

tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session -d
$XDG_DATA_HOME/tmux/plugins/tpm/bindings/install_plugins
tmux kill-server

# gnupg

export GNUPGHOME=$XDG_DATA_HOME/gnupg

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

export PASSWORD_STORE_DIR=$XDG_DATA_HOME/pass

pass init grzegorz.kozub@gmail.com

# shared

. `dirname $0`/shared.zsh

# node

export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
# export NPM_CONFIG_PREFIX=$XDG_DATA_HOME/npm

nvm install node --latest-npm
nvm install-latest-npm
nvm cache clear

npm install --global \
  autocannon \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  rimraf \
  typescript \
  typescript-formatter

# neovim

nvim --headless -c 'autocmd User PackerComplete quitall'

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

