set -e -o verbose

# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# repo

pushd `dirname $0`

git submodule update --init
git submodule foreach --recursive git checkout master

git update-index --assume-unchanged \
  keepass.arch/keepassxc/keepassxc.ini \
  keepass.mac/KeePassXC/keepassxc.ini

popd

# links

if [ ! -d ~/.config ]; then mkdir ~/.config; fi

stow --dir=`dirname $0` --target=$HOME/.config --stow \
  ranger

stow --dir=`dirname $0` --target=$HOME --stow \
  elixir \
  git \
  node \
  tmux \
  vim \
  zsh

ln -sfT $(dirname $(realpath $0))/vim/.vim ~/.config/nvim

if [[ $MAC ]]; then

  stow --dir=`dirname $0` \
    --target=$HOME/Library/Application\ Support --stow \
    keepass.mac \
    vscode

else

  stow --dir=`dirname $0` --target=$HOME/.config --stow \
    keepass.arch \
    vscode

fi

# cleanup

unset LINUX MAC

