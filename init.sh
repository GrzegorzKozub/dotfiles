set -e -o verbose

# repo

pushd `dirname $0`

git submodule update --init
git submodule foreach --recursive git checkout master

git update-index --assume-unchanged \
  keepass.arch/keepassxc/keepassxc.ini \
  keepass.mac/KeePassXC/keepassxc.ini

popd

# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# dirs

CONFIG_DIR=${XDG_CONFIG_HOME:-~/.config}
[[ -d $CONFIG_DIR ]] || mkdir -p $CONFIG_DIR

# links

stow --dir=`dirname $0` --target=$CONFIG_DIR --stow \
  git \
  iex \
  ranger \
  tmux \
  vim \
  zsh

[[ -d $CONFIG_DIR/nvim ]] && rm $CONFIG_DIR/nvim
ln -s $(dirname $(realpath $0))/vim/vim $CONFIG_DIR/nvim

if [[ $LINUX ]]; then

  stow --dir=`dirname $0` --target=$CONFIG_DIR --stow \
    chrome \
    environment.arch \
    flameshot \
    keepass.arch \
    vscode

fi

if [[ $MAC ]]; then

  stow --dir=`dirname $0` \
    --target=$HOME/Library/LaunchAgents --stow \
    environment.mac

  launchctl unload ~/Library/LaunchAgents/environment.plist
  launchctl load ~/Library/LaunchAgents/environment.plist

  stow --dir=`dirname $0` \
    --target=$HOME/Library/Application\ Support --stow \
    keepass.mac \
    vscode

fi

# cleanup

unset LINUX MAC CONFIG_DIR

