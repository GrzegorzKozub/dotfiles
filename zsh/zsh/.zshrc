# dirs

[[ -d ${XDG_CACHE_HOME:-~/.cache}/zsh ]] || mkdir -p ${XDG_CACHE_HOME:-~/.cache}/zsh
[[ -d ${XDG_DATA_HOME:-~/.local/share}/zsh ]] || mkdir -p ${XDG_DATA_HOME:-~/.local/share}/zsh

# paths

typeset -U path

path=(
  ~/.local/bin
  ~/.local/share/cargo/bin
  ~/.local/share/gem/ruby/3.0.0/bin
  ~/.local/share/go/bin
  ~/.local/share/mix/escripts
  ~/.local/share/npm/bin
  ~/code/apsis
  ~/code/arch
  $path[@]
)

# terminal emulator title

zstyle ':prezto:module:terminal' auto-title 'yes'

# theme

export MY_THEME='gruvbox-dark'

# plugins

declare -A ZINIT
export ZINIT[HOME_DIR]=${XDG_DATA_HOME:-~/.local/share}/zinit
export ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump

source $ZINIT[HOME_DIR]/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light softmoth/zsh-vim-mode

# zinit ice wait lucid
# zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh # after zsh-vim-mode

zinit snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/dirhistory/dirhistory.plugin.zsh # after zsh-vim-mode

zinit ice lucid depth=1
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice nocompile lucid depth=1 \
  atload"source ./zsh/$MY_THEME.sh" \
  atload"fast-theme ./fast-syntax-highlighting/$MY_THEME.ini --quiet"
zinit light GrzegorzKozub/themes # after zsh-vim-mode and fast-syntax-highlighting

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit ice depth=1
zinit light romkatv/zsh-defer

zinit snippet PZT::modules/terminal/init.zsh

zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker/_docker
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker-compose/_docker-compose
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/docker-machine/_docker-machine
zinit ice wait lucid as'completion'
zinit snippet OMZ::plugins/pip/_pip

# options

setopt AUTO_PUSHD # pushd on every cd
setopt CORRECT_ALL
setopt NO_BEEP
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS # cd - goes to the previous dir

[[ -o login ]] && stty -ixon # disable flow control (^s and ^c)

zle_bracketed_paste=() # don't select pasted text

export EDITOR='nvim'
export DIFFPROG='nvim -d'
export VISUAL='nvim'

# colors

autoload -Uz colors && colors

eval $(dircolors -b ${XDG_CONFIG_HOME:-~/.config}/zsh/dir_colors)

palette() {
  for color in {0..15}; do
    print -Pn "%K{$color}  %k%F{$color}${(l:2::0:)color}%f "
  done
  print '\n'
}

# prompt

autoload -Uz promptinit && promptinit
setopt PROMPT_SUBST

# completion

typeset -U fpath

fpath=(
  ~/code/apsis
  ~/code/arch
  $fpath[@]
)

WORDCHARS=''

setopt ALWAYS_TO_END # put cursor at the end of completed word
setopt AUTO_MENU # show completion menu after pressing tab second time
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD # complete from both ends of word
setopt EXTENDED_GLOB
setopt LIST_PACKED
setopt MENU_COMPLETE # highlight first completion menu item
setopt PATH_DIRS # search for paths on commands with slashes

zmodload -i zsh/complist
autoload -Uz compinit && compinit -d ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompcache

zstyle ':completion:*' completer _complete _match _approximate

zstyle ':completion:*' list-separator '-'
zstyle ':completion:*' menu select

zstyle ':completion:*:default' list-colors '=(#b)*( - *)=37=38;5;8' '=*=37' 'ma=0' 'tc=37'

zstyle ':completion:*:messages' format '%F{white}%d%f'
zstyle ':completion:*:warnings' format '%F{yellow}no matches found%f'

# try case-sensitive match first and match partial words
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# complete not only for dir stack but also for options on -
zstyle ':completion:*' complete-options true

# correct single char typos
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# complete environment variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# expand // to /
zstyle ':completion:*' squeeze-slashes true

# up and down for muti-line commands in command mode
bindkey -M vicmd '^[[A' up-line-or-history
bindkey -M vicmd '^[[B' down-line-or-history

# up and down history completion in insert mode

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search

# history

HISTFILE=${XDG_DATA_HOME:-~/.local/share}/zsh/history

HISTSIZE=10000 # history memory limit
SAVEHIST=10000 # history file limit

HISTORY_IGNORE='(#i)(*bearer*|exit|*password*|*secret*|*token*)'

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # don't add commands prefixed with space
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY # don't run command immediately
setopt INC_APPEND_HISTORY # add commands immediately

# aliases

alias clip='xclip -selection clipboard'
alias df='df -h'
alias diff='diff --color'
alias du='du -hd1'
alias grep='grep --color=auto --exclude-dir={.git}'
alias la='ls -lAh'
alias ls='ls --color=auto'

# macros

my-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N my-redraw-prompt

bind() {
  zle -N $2
  bindkey -M vicmd $1 $2
  bindkey -M viins $1 $2
}

my-exit() { exit }; bind '\ex' my-exit

dir() { cd $1; zle my-redraw-prompt }

my-config() { dir $XDG_CONFIG_HOME }; bind '^gxc' my-config
my-cache() { dir $XDG_CACHE_HOME }; bind '^gxa' my-cache
my-config() { dir $XDG_DATA_HOME }; bind '^gxd' my-data

my-code() { dir ~/code }; bind '^gc' my-code

my-data() { dir /run/media/$USER/data }; bind '^gd' my-data
my-games() { dir /run/media/$USER/games }; bind '^gg' my-games

# aws

export AWS_CONFIG_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/config
export AWS_SHARED_CREDENTIALS_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/credentials
export AWS_PROFILE=apsis-waw-stage
export AWS_SDK_LOAD_CONFIG=1

autoload -Uz bashcompinit && bashcompinit
complete -C /usr/bin/aws_completer aws

alias myip="curl http://checkip.amazonaws.com/"

# docker

export DOCKER_CONFIG=${XDG_CONFIG_HOME:-~/.config}/docker

# dotnet

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export OMNISHARPHOME=${XDG_DATA_HOME:-~/.local/share}/omnisharp

# elixir

export ERL_AFLAGS='-kernel shell_history enabled'

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex
export MIX_HOME=${XDG_DATA_HOME:-~/.local/share}/mix

alias iex="iex --dot-iex ${XDG_CONFIG_HOME:-~/.config}/iex/iex.exs"

# freerdp

rdp() {
  xfreerdp $1 /size:1920x1080 /dynamic-resolution /cert-ignore /drive:/home/$USER/Downloads
}

# fzf

zsh-defer source /usr/share/fzf/completion.zsh
zsh-defer source /usr/share/fzf/key-bindings.zsh

export FZF_DEFAULT_OPTS="
  --color dark,bg+:-1,fg:$MY_FZF_COLOR_FG,fg+:-1,hl:$MY_FZF_COLOR_HL,hl+:$MY_FZF_COLOR_HL
  --color spinner:-1,info:-1,prompt:$MY_FZF_COLOR_PROMPT,pointer:$MY_FZF_COLOR_POINTER,marker:$MY_FZF_COLOR_MARKER
  --ellipsis '…'
  --layout reverse-list
  --margin 0,0,0,0
  --marker '$MY_FZF_CHAR_MARKER'
  --no-bold
  --no-info
  --no-scrollbar
  --pointer '$MY_FZF_CHAR_POINTER'
  --prompt '$MY_FZF_CHAR_PROMPT'
  --tabstop 2
"

# default bindings in vicmd and viins:
# ^[c  fzf-cd-widget
# ^r   fzf-history-widget
# ^t   fzf-file-widget

# git

my-git-checkout-branch() {
  BUFFER='git checkout -b sc-'
  zle vi-end-of-line
  zle vi-insert
}
bind '\ebranch' my-git-checkout-branch

my-git-commit() {
  BUFFER='git commit -m " [sc-]"'
  zle vi-end-of-line
  for i in $(seq 2); do zle vi-backward-word; done
  for i in $(seq 2); do zle vi-backward-char; done
  zle vi-insert
}
bind '\ecommit' my-git-commit

# gnupg

export GNUPGHOME=${XDG_DATA_HOME:-~/.local/share}/gnupg

# less

export LESSHISTFILE=-
export MANPAGER="less +Gg -R -s --use-color -DPw -DSkY -Ddy -Dsm -Dub"

alias less='less --raw-control-chars'

# lf

my-cd() {
  local temp_file=$1
  if [[ -f "$temp_file" ]]; then
    local target_dir="$(cat "$temp_file")"
    rm -f "$temp_file"
    [[ -d "$target_dir" && "$target_dir" != "$(pwd)" ]] && cd "$target_dir"
  fi
  zle my-redraw-prompt
}

my-lf-cd() {
  local temp_file="$(mktemp)"
  lf -last-dir-path="$temp_file" "$@" < $TTY
  my-cd $temp_file
}
bind '\el' my-lf-cd

# neovim

alias vim='nvim'

# node

export NODE_REPL_HISTORY=''

export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME:-~/.config}/npm/npmrc

export NVM_DIR=${XDG_DATA_HOME:-~/.local/share}/nvm
zsh-defer source $NVM_DIR/nvm.sh --no-use

export NG_CLI_ANALYTICS=ci

# pass

export PASSWORD_STORE_DIR=${XDG_DATA_HOME:-~/.local/share}/pass

# python

export PYLINTHOME=${XDG_CACHE_HOME:-~/.cache}/pylint

# ripgrep

export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME:-~/.config}/ripgrep/ripgreprc

# rust

export CARGO_HOME=${XDG_DATA_HOME:-~/.local/share}/cargo
export RUSTUP_HOME=${XDG_DATA_HOME:-~/.local/share}/rustup

# tmux

alias tmux="tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf"

# vscode

alias code='code 2> /dev/null'

# wget

alias wget="wget --hsts-file=${XDG_CACHE_HOME:-~/.cache}/wget-hsts"

# zsh-vim-mode

MODE_CURSOR_VIINS='blinking bar'
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VISUAL=$MODE_CURSOR_VICMD
MODE_CURSOR_VLINE=$MODE_CURSOR_VISUAL
MODE_CURSOR_REPLACE=$MODE_CURSOR_VIINS
MODE_CURSOR_SEARCH='steady underline'

# powerlevel10k

[[ -f ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh ]] && source ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh

# env

[[ -f ${XDG_CONFIG_HOME:-~/.config}/zsh/env.zsh ]] && . ${XDG_CONFIG_HOME:-~/.config}/zsh/env.zsh

# tmux

[[ $TERM_PROGRAM = 'vscode' ]] || [[ ! -z $TMUX ]] || tmux attach || tmux new
