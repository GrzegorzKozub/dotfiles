set -e -o verbose

# zsh

if [ -d ~/.local/share/zinit ]; then rm -rf ~/.local/share/zinit; fi
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma/zinit.git ~/.local/share/zinit/bin

# tmux

if [ -d ~/.local/share/tmux ]; then rm -rf ~/.local/share/tmux; fi
mkdir -p ~/.local/share/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm
tmux new-session -d
~/.local/share/tmux/plugins/tpm/bindings/install_plugins
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

