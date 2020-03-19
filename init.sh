set -e -o verbose

# repo

pushd `dirname $0`
git submodule update --init
git submodule foreach --recursive git checkout master
git update-index --assume-unchanged keepass/keepassxc/keepassxc.ini
popd

# links

if [ ! -d ~/.config ]; then mkdir ~/.config; fi

stow --dir=`dirname $0` --target=$HOME/.config --stow \
  keepass \
  ranger \
  vscode

stow --dir=`dirname $0` --target=$HOME --stow \
  elixir \
  git \
  node \
  tmux \
  vim \
  zsh

ln -sf $(dirname $(realpath $0))/vim/.vim ~/.config/nvim

