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
  ~/.local/share/npm/bin
  ~/code/arch
  $path[@]
)

# terminal

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

zinit ice wait lucid
zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh # after zsh-vim-mode

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

setopt auto_pushd # pushd on every cd
setopt correct_all
setopt no_beep
setopt pushd_ignore_dups
setopt pushd_minus # cd - goes to the previous dir

[[ -o login ]] && stty -ixon # disable flow control (^s and ^c)

zle_bracketed_paste=() # don't select pasted text

export EDITOR='nvim'

# colors

autoload -Uz colors && colors

() {
  if [[ -z $LS_COLORS ]] && (( $+commands[dircolors] )); then
    local colors_file=${XDG_CACHE_HOME:-~/.cache}/zsh/dir_colors
    if [[ ! -f $colors_file ]]; then
      dircolors --print-database > $colors_file
      sed -i 's/ 01;/ 00;/' $colors_file
      sed -i 's/;01 /;00 /' $colors_file
    fi
    eval `dircolors -b $colors_file`
  fi
}

function palette {
   for color in {0..15}; do
     print -Pn "%K{$color}  %k%F{$color}${(l:2::0:)color}%f "
   done
   print '\n'
}

# prompt

autoload -Uz promptinit && promptinit
setopt prompt_subst

# completion

WORDCHARS=''

autoload -Uz compinit && compinit -d ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump

setopt always_to_end # put cursor at the end of completed word
setopt auto_menu # show completion menu on 2nd tab
setopt complete_aliases
setopt complete_in_word # complete from both words ends
setopt extended_glob
setopt path_dirs # search for paths on commands with slashes

zstyle ':completion:*' menu select
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'

# complete environment variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# correct single char typos
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

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
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history # record timestamps
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify # don't run command immediately
setopt inc_append_history # add commands in the order of execution
setopt share_history # share history between terminals

# aliases

alias clip='xclip -selection clipboard'
alias df='df -h'
alias diff='diff --color'
alias du='du -hd1'
alias grep='grep --color=auto --exclude-dir={.git}'
alias la='ls -lAh'
alias less='less --raw-control-chars'
alias ls='ls --color=auto'
alias repos='. ~/code/apsis/repos.zsh'

# dirhistory

() {
  local alt='^[[1;3'

  bindkey -M vicmd "${alt}D" dirhistory_zle_dirhistory_back
  bindkey -M vicmd "${alt}C" dirhistory_zle_dirhistory_future
  bindkey -M vicmd "${alt}A" dirhistory_zle_dirhistory_up
  bindkey -M vicmd "${alt}B" dirhistory_zle_dirhistory_down
}

# my-exit

function my-exit { exit }
zle -N my-exit

bindkey -M vicmd '\ex' my-exit
bindkey -M viins '\ex' my-exit

# my-cd

function my-redraw-prompt {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N my-redraw-prompt

function my-cd {
  local temp_file=$1
  if [[ -f "$temp_file" ]]; then
    local target_dir="$(cat "$temp_file")"
    rm -f "$temp_file"
    [[ -d "$target_dir" && "$target_dir" != "$(pwd)" ]] && cd "$target_dir"
  fi
  zle my-redraw-prompt
}

# my-git-checkout-branch

function my-git-checkout-branch {
  BUFFER='git checkout -b sc-'
  zle vi-end-of-line
  zle vi-insert
}
zle -N my-git-checkout-branch

bindkey -M vicmd '\egcb' my-git-checkout-branch
bindkey -M viins '\egcb' my-git-checkout-branch

# my-git-commit

function my-git-commit {
  BUFFER='git commit -m " [sc-]"'
  zle vi-end-of-line
  zle vi-backward-word
  zle vi-backward-word
  zle vi-backward-char
  zle vi-backward-char
  zle vi-insert
}
zle -N my-git-commit

bindkey -M vicmd '\egc' my-git-commit
bindkey -M viins '\egc' my-git-commit

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

function rdp {
  xfreerdp $1 /size:1920x1080 /dynamic-resolution /cert-ignore /drive:/home/greg/Downloads
}

# fzf

export FZF_DEFAULT_OPTS="
  --color dark,bg+:-1,fg:$MY_FZF_COLOR_LIGHT,fg+:-1,hl:$MY_FZF_COLOR_ACCENT,hl+:$MY_FZF_COLOR_ACCENT
  --color spinner:-1,info:-1,prompt:$MY_FZF_COLOR_ACCENT,pointer:$MY_FZF_COLOR_DARK,marker:$MY_FZF_COLOR_DARK
  --layout reverse-list
  --margin 0,0,0,0
  --marker '$MY_FZF_CHAR_MARKER'
  --no-bold
  --no-info
  --pointer '$MY_FZF_CHAR_POINTER'
  --prompt '$MY_FZF_CHAR_PROMPT'
  --tabstop 2
"

bindkey -M vicmd '^[c' fzf-cd-widget
bindkey -M vicmd '^r' fzf-history-widget
bindkey -M vicmd '^t' fzf-file-widget

# gnupg

export GNUPGHOME=${XDG_DATA_HOME:-~/.local/share}/gnupg

# less

export LESSHISTFILE=-

# lf

function my-lf-cd {
  local temp_file="$(mktemp)"
  lf -last-dir-path="$temp_file" "$@" < $TTY
  my-cd $temp_file
}
zle -N my-lf-cd

bindkey -M vicmd '\el' my-lf-cd
bindkey -M viins '\el' my-lf-cd

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

# vim

export VIMINIT='let $MYVIMRC="'${XDG_CONFIG_HOME:-~/.config}'/vim/vimrc" | source $MYVIMRC'

alias vim='nvim'

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

# tmux

[[ $TERM_PROGRAM = 'vscode' ]] || [[ ! -z $TMUX ]] || tmux attach || tmux new
