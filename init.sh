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

# zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# tmux

if [ -d ~/.tmux/plugins/tpm ]; then rm -rf ~/.tmux/plugins/tpm; fi
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d
~/.tmux/plugins/tpm/bindings/install_plugins

# ranger

if [ -d ~/ranger_devicons ]; then rm -rf ~/ranger_devicons; fi
pushd ~
git clone https://github.com/alexanderjeurissen/ranger_devicons
cd ranger_devicons
make install
popd
rm -rf ~/ranger_devicons

# vim and neovim

vim -c 'PlugInstall'

