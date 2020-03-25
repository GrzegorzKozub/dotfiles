set -e -o verbose

# zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# tmux

if [ -d ~/.tmux/plugins ]; then rm -rf ~/.tmux/plugins; fi
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d
~/.tmux/plugins/tpm/bindings/install_plugins
tmux kill-server

# ranger

# if [ -d ~/ranger_devicons ]; then rm -rf ~/ranger_devicons; fi
# pushd ~
# git clone https://github.com/alexanderjeurissen/ranger_devicons
# cd ranger_devicons
# make install
# popd
# rm -rf ~/ranger_devicons

# vim and neovim

nvim --headless +PlugInstall +qall

