# perf check: for i in $(seq 1 10); do time zsh -i -c exit; done
# key scan: cat -v or showkey -a

# dirs

[[ -d ${XDG_CACHE_HOME:-~/.cache}/zsh ]] || mkdir -p ${XDG_CACHE_HOME:-~/.cache}/zsh
# [[ -d ${XDG_DATA_HOME:-~/.local/share}/zsh ]] || mkdir -p ${XDG_DATA_HOME:-~/.local/share}/zsh

# plugin support

declare -A ZINIT
export ZINIT[HOME_DIR]=${XDG_DATA_HOME:-~/.local/share}/zinit
export ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump

source $ZINIT[HOME_DIR]/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# delay support

zinit ice depth=1 && zinit light romkatv/zsh-defer

# theme

export MY_THEME='gruvbox-dark'
source ${XDG_CONFIG_HOME:-~/.config}/zsh/$MY_THEME.zsh

# functions

my-bindkey() {
  for keymap in vicmd viins; do bindkey -M $keymap $1 $2; done
}

my-redraw-prompt() {
  for precmd in $precmd_functions; do $precmd; done
  zle reset-prompt
  zle zle-keymap-select
}
zle -N my-redraw-prompt

palette() {
  for color in {0..15}; do
    print -Pn "%K{$color}  %k%F{$color}${(l:2::0:)color}%f "
  done
  print '\n'
}

# vi mode

# zsh-defer zinit light softmoth/zsh-vim-mode
# zinit snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh

my-bindkey '^[[1;5D' backward-word # ctrl+left
my-bindkey '^[[1;5C' forward-word # ctrl+right

my-bindkey '^[[1~' beginning-of-line # home
my-bindkey '^[[4~' end-of-line # end

my-bindkey '^P' up-history # ctrl+p
my-bindkey '^N' down-history # ctrl+n

my-bindkey '^[[3~' delete-char # delete
bindkey -M viins '^?' backward-delete-char # backspace

# complete from history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins '^[[A' up-line-or-beginning-search # up
bindkey -M viins '^[[B' down-line-or-beginning-search # down

# handle muti-line commands
bindkey -M vicmd '^[[A' up-line-or-history # up
bindkey -M vicmd '^[[B' down-line-or-history # down

autoload -U select-bracketed select-quoted surround
zle -N select-bracketed
zle -N select-quoted
zle -N add-surround surround
zle -N delete-surround surround
zle -N change-surround surround

for keymap in viopp visual; do
  for sequence in {a,i}${(s..)^:-'()[]{}<>bB'}; do bindkey -M $keymap $sequence select-bracketed; done
  for sequence in {a,i}{\',\",\`}; do bindkey -M $keymap $sequence select-quoted; done
done

bindkey -M visual 'S' add-surround
bindkey -M vicmd 'cs' change-surround
bindkey -M vicmd 'ds' delete-surround

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# vi mode cursor

function my-cursor() {
  case ${1:-'main'} in vicmd|viopp|visual) local shape=2;; main|viins|*) local shape=6;; esac
  printf $'\e[%d q' $shape
}

function zle-keymap-select() { my-cursor $KEYMAP }
zle -N zle-keymap-select

function zle-line-init() { my-cursor main }
zle -N zle-line-init

function my-visual-mode { my-cursor visual && zle .visual-mode }
zle -N visual-mode my-visual-mode

# options

setopt AUTO_PUSHD # pushd on every cd
setopt CORRECT_ALL
setopt NO_BEEP
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS # cd - goes to the previous dir

[[ -o login ]] && stty -ixon # disable flow control (^s and ^c)

zle_bracketed_paste=() # don't select pasted text

zstyle ':prezto:module:terminal' auto-title 'yes'

# prompt

autoload -Uz promptinit && promptinit

setopt PROMPT_SUBST

zinit ice depth=1
zinit light romkatv/powerlevel10k

# aliases

alias df='df -h'
alias diff='diff --color'
alias du='du -hd1'
alias grep='grep --color=auto --exclude-dir={.git}'
alias la='ls -lAh'
alias ls='ls --color=auto'

# paths

typeset -U path

path=(
  ~/.local/bin
  ~/.local/share/cargo/bin
  ~/.local/share/gem/ruby/3.0.0/bin
  ~/.local/share/go/bin
  ~/code/apsis
  ~/code/arch
  $path[@]
)

  # ~/.local/share/npm/bin

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

zsh-defer zmodload -i zsh/complist
zsh-defer autoload -Uz compinit && zsh-defer compinit -d ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump
zsh-defer autoload -Uz bashcompinit && zsh-defer bashcompinit # required by aws

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

zinit wait lucid as'completion' for \
  OMZ::plugins/docker-compose/_docker-compose \
  OMZ::plugins/docker-machine/_docker-machine \
  OMZ::plugins/pip/_pip

# history

# HISTFILE=${XDG_DATA_HOME:-~/.local/share}/zsh/history
HISTFILE=~/code/history/$HOST/history

HISTSIZE=10000 # history memory limit
SAVEHIST=10000 # history file limit

HISTORY_IGNORE='(#i)(*bearer*|*password*|*secret*|*token*)'

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # don't add commands prefixed with space
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY # don't run command immediately
setopt INC_APPEND_HISTORY # add commands immediately

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

fzf-history-widget-no-numbers() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  local opts="--height ${FZF_TMUX_HEIGHT:-40%}
    $FZF_DEFAULT_OPTS --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore
    $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m"
  local selected=( $( fc -rln 1 | FZF_DEFAULT_OPTS=$opts $(__fzfcmd) ) )
  local ret=$?
  BUFFER=$selected
  zle vi-end-of-line
  zle reset-prompt
  return $ret
}
zsh-defer zle -N fzf-history-widget-no-numbers
zsh-defer my-bindkey '^r' fzf-history-widget-no-numbers

# last working dir

zinit snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh

# dir history

zsh-defer zinit snippet OMZ::plugins/dirhistory/dirhistory.plugin.zsh

zsh-defer bindkey -r '^[^[[D' # esc+left
zsh-defer bindkey -r '^[^[[C' # esc+right
zsh-defer bindkey -r '^[^[[B' # esc+up
zsh-defer bindkey -r '^[^[[A' # esc+down

# dir shortcuts

my-dir() { cd $1; zle my-redraw-prompt }

my-cache() { my-dir $XDG_CACHE_HOME }; zle -N my-cache; my-bindkey '^gxa' my-cache
my-config() { my-dir $XDG_CONFIG_HOME }; zle -N my-config; my-bindkey '^gxc' my-config
my-share() { my-dir $XDG_DATA_HOME }; zle -N my-share; my-bindkey '^gxd' my-share

my-code() { my-dir ~/code }; zle -N my-code; my-bindkey '^gc' my-code

my-data() { my-dir /run/media/$USER/data }; zle -N my-data; my-bindkey '^gd' my-data
my-games() { my-dir /run/media/$USER/games }; zle -N my-games; my-bindkey '^gg' my-games

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
zle -N my-lf-cd
my-bindkey '\el' my-lf-cd viins vicmd

# dir colors

autoload -Uz colors && colors

eval $(dircolors -b ${XDG_CONFIG_HOME:-~/.config}/zsh/dir_colors)

# syntax highlighting

# using zinit's wait ice instead of zsh-defer causes delays when typing zinit command
zsh-defer zinit ice lucid depth=1 atload"fast-theme XDG:$MY_THEME --quiet"
zsh-defer zinit light zdharma-continuum/fast-syntax-highlighting

# aws

export AWS_CONFIG_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/config
export AWS_SHARED_CREDENTIALS_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/credentials
export AWS_PROFILE=apsis-waw-stage
export AWS_SDK_LOAD_CONFIG=1

zsh-defer complete -C /usr/bin/aws_completer aws

alias myip='curl http://checkip.amazonaws.com/'

# docker

export DOCKER_CONFIG=${XDG_CONFIG_HOME:-~/.config}/docker

if [[ ! -f "${XDG_CACHE_HOME:-~/.cache}/zsh/_docker" ]]; then
  typeset -g -A _comps
  autoload -Uz _docker
  _comps[docker]=_docker
fi
zsh-defer docker completion zsh >| "${XDG_CACHE_HOME:-~/.cache}/zsh/_docker"

# dotnet

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export OMNISHARPHOME=${XDG_DATA_HOME:-~/.local/share}/omnisharp

_dotnet_zsh_complete() {
  local completions=("$(dotnet complete "$words")")
  if [ -z "$completions" ]; then
    _arguments '*::arguments: _normal'
    return
  fi
  _values = "${(ps:\n:)completions}"
}
zsh-defer compdef _dotnet_zsh_complete dotnet

# elixir

export ERL_AFLAGS='-kernel shell_history enabled'

export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex
export MIX_HOME=${XDG_DATA_HOME:-~/.local/share}/mix

alias iex="iex --dot-iex ${XDG_CONFIG_HOME:-~/.config}/iex/iex.exs"

# freerdp

rdp() {
  xfreerdp $1 /size:1920x1080 /dynamic-resolution /cert-ignore /drive:/home/$USER/Downloads
}

# git

my-git-checkout-branch() {
  BUFFER='git checkout -b sc-'
  zle vi-end-of-line
  zle vi-insert
}
zle -N my-git-checkout-branch
my-bindkey '\ebranch' my-git-checkout-branch viins vicmd

my-git-commit() {
  BUFFER="git commit -m ' [sc-]'"
  zle vi-end-of-line
  for i in $(seq 2); do zle vi-backward-word; done
  for i in $(seq 2); do zle vi-backward-char; done
  zle vi-insert
}
zle -N my-git-commit
my-bindkey '\ecommit' my-git-commit viins vicmd

# gnupg

export GNUPGHOME=${XDG_DATA_HOME:-~/.local/share}/gnupg

# less

export LESSHISTFILE=-
export MANPAGER='less --RAW-CONTROL-CHARS +Gg --squeeze-blank-lines --use-color -DPw -DSkY -Ddy -Dsm -Dub'

alias less='less --quit-if-one-screen --RAW-CONTROL-CHARS --use-color -DPw -DSkY -Ddy -Dsm -Dub'

# neovim

export EDITOR='nvim'
export DIFFPROG='nvim -d'
export VISUAL='nvim'

alias vim='nvim'

# node

export NODE_REPL_HISTORY=''

export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME:-~/.config}/npm/npmrc
# export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm

export NVM_DIR=${XDG_DATA_HOME:-~/.local/share}/nvm
zsh-defer source $NVM_DIR/nvm.sh # --no-use

# my-nvm-use-node() {
#   [[ -f package.json ]] && (( ! $+commands[node] )) && zsh-defer nvm use node
# }
# add-zsh-hook chpwd my-nvm-use-node && my-nvm-use-node

# pass

export PASSWORD_STORE_DIR=${XDG_DATA_HOME:-~/.local/share}/pass

# pkgfile

zsh-defer source /usr/share/doc/pkgfile/command-not-found.zsh

# python

export PYLINTHOME=${XDG_CACHE_HOME:-~/.cache}/pylint

# ripgrep

export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME:-~/.config}/ripgrep/ripgreprc

# rust

export CARGO_HOME=${XDG_DATA_HOME:-~/.local/share}/cargo
export RUSTUP_HOME=${XDG_DATA_HOME:-~/.local/share}/rustup

# tmux

alias tmux="tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf"

# vi-mode

# VI_MODE_CURSOR_VISUAL=2
# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# VI_MODE_SET_CURSOR=true

# vscode

alias code='code 2> /dev/null'

# wget

alias wget="wget --hsts-file=${XDG_CACHE_HOME:-~/.cache}/wget-hsts"

# zsh-vim-mode

# MODE_CURSOR_VIINS='blinking bar'
# MODE_CURSOR_VICMD='blinking block'
# MODE_CURSOR_VISUAL=$MODE_CURSOR_VICMD
# MODE_CURSOR_VLINE=$MODE_CURSOR_VISUAL
# MODE_CURSOR_REPLACE=$MODE_CURSOR_VIINS
# MODE_CURSOR_SEARCH='steady underline'

# print -n "\e[5 q" # the use of zsh-defer requires to manually set the cursor to blinking bar

# powerlevel10k

[[ -f ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh ]] && source ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh

# env

[[ -f ${XDG_CONFIG_HOME:-~/.config}/zsh/env.zsh ]] && . ${XDG_CONFIG_HOME:-~/.config}/zsh/env.zsh

# tmux

[[ $TERM_PROGRAM = 'vscode' ]] || [[ ! -z $TMUX ]] || tmux attach || tmux new
