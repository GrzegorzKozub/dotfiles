set -e -o verbose

# env

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export GOPATH=$XDG_DATA_HOME/go

# dirs

DATA_DIR=${XDG_DATA_HOME:-~/.local/share}
[[ -d $DATA_DIR ]] || mkdir -p $DATA_DIR

# zsh

if [ -d $DATA_DIR/zinit ]; then rm -rf $DATA_DIR/zinit; fi
mkdir -p $DATA_DIR/zinit
git clone https://github.com/zdharma/zinit.git $DATA_DIR/zinit/bin

# tmux

if [ -d $DATA_DIR/tmux ]; then rm -rf $DATA_DIR/tmux; fi
mkdir -p $DATA_DIR/tmux/plugins
git clone https://github.com/tmux-plugins/tpm $DATA_DIR/tmux/plugins/tpm
tmux new-session -d
$DATA_DIR/tmux/plugins/tpm/bindings/install_plugins
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

# dotnet

dotnet tool install --global dotnet-counters
dotnet tool install --global dotnet-dump
dotnet tool install --global dotnet-format
dotnet tool install --global dotnet-outdated
dotnet tool install --global dotnet-trace

# elixir

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# go

for PACKAGE_FOR_VSCODE in \
  github.com/acroca/go-symbols \
  github.com/cweill/gotests/... \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/fatih/gomodifytags \
  github.com/go-delve/delve/cmd/dlv \
  github.com/godoctor/godoctor \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/josharian/impl \
  github.com/mdempsky/gocode \
  github.com/ramya-rao-a/go-outline \
  github.com/rogpeppe/godef \
  github.com/stamblerre/gocode \
  github.com/uudashr/gopkgs/cmd/gopkgs \
  golang.org/x/lint/golint \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/gorename \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/gopls
do
  echo $PACKAGE_FOR_VSCODE
  go get -u $PACKAGE_FOR_VSCODE
done

for PACKAGE_FOR_VIM in \
  `#github.com/davidrjenni/reftools/cmd/fillstruct` \
  `#github.com/fatih/gomodifytags` \
  github.com/fatih/motion \
  `#github.com/go-delve/delve/cmd/dlv` \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  `#github.com/josharian/impl` \
  github.com/jstemmer/gotags \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/koron/iferr \
  `#github.com/mdempsky/gocode` \
  `#github.com/rogpeppe/godef` \
  `#github.com/stamblerre/gocode` \
  github.com/zmb3/gogetdoc \
  `#golang.org/x/lint/golint` \
  `#golang.org/x/tools/cmd/goimports` \
  `#golang.org/x/tools/cmd/gorename` \
  `#golang.org/x/tools/cmd/guru` \
  `#golang.org/x/tools/gopls` \
  honnef.co/go/tools/cmd/keyify
do
  echo $PACKAGE_FOR_VIM
  go get -u $PACKAGE_FOR_VIM
done

# node

npm install --global \
  @angular/cli \
  create-react-app \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  pm2 \
  rimraf \
  typescript \
  typescript-formatter

# python

pip install --user \
  awscli \
  docker-compose \
  lastversion \
  pynvim

# pip install --user \
#   awsebcli

pip install --user --pre \
  vim-vint

# ruby

gem install --user-install \
  neovim

# vscode

for EXTENSION in \
  JakeBecker.elixir-ls \
  alexkrechik.cucumberautocomplete \
  aws-scripting-guy.cform \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  equinusocio.vsc-material-theme \
  esbenp.prettier-vscode \
  `# humao.rest-client` \
  ms-azuretools.vscode-docker \
  `# ms-kubernetes-tools.vscode-kubernetes-tools` \
  `# ms-vscode-remote.remote-containers` \
  `# ms-vscode-remote.remote-ssh` \
  `# ms-vscode-remote.remote-wsl` \
  `# ms-vscode.PowerShell` \
  `# ms-vscode.azure-account` \
  `# ms-vscode.csharp` \
  ms-vscode.go \
  ms-vscode.vscode-typescript-tslint-plugin \
  `# msjsdiag.debugger-for-chrome` \
  pkief.material-icon-theme \
  redhat.vscode-yaml
do
  code --install-extension $EXTENSION --force
done

code --uninstall-extension equinusocio.vsc-community-material-theme
code --uninstall-extension equinusocio.vsc-material-theme-icons

# cleanup

unset DATA_DIR
