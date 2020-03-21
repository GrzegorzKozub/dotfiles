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
git update-index --assume-unchanged keepass/keepassxc/keepassxc.ini
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

ln -sf $(dirname $(realpath $0))/vim/.vim ~/.config/nvim

if [[ $MAC ]]; then

  ln -sf $(dirname $(realpath $0))/keepass.mac/KeePassXC \
    ~/Library/Application\ Support/KeePassXC

  ln -sf $(dirname $(realpath $0))/vscode/Code \
    ~/Library/Application\ Support/Code

else

  stow --dir=`dirname $0` --target=$HOME/.config --stow \
    keepass \
    vscode

fi

# cleanup

unset LINUX MAC

