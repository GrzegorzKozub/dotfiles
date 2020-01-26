set -e -o verbose

# zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# tmux

if [ -d ~/.tmux/plugins/tpm ]; then rm -rf ~/.tmux/plugins/tpm; fi
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bindings/install_plugins

systemctl --user enable tmux

# ranger

if [ -d ~/ranger_devicons ]; then rm -rf ~/ranger_devicons; fi
pushd ~
git clone https://github.com/alexanderjeurissen/ranger_devicons
cd ranger_devicons
make install
popd
rm -rf ~/ranger_devicons

# vim and neovim

vim -c 'PlugInstall | qall'
ln -sf ~/.vim  ~/.config/nvim

