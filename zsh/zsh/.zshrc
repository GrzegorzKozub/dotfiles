# os

case $(uname -s) in
  'Linux') LINUX=1;;
  'Darwin') MAC=1;;
esac

# dirs

[[ -d ${XDG_CACHE_HOME:-~/.cache}/zsh ]] || mkdir -p ${XDG_CACHE_HOME:-~/.cache}/zsh
[[ -d ${XDG_DATA_HOME:-~/.local/share}/zsh ]] || mkdir -p ${XDG_DATA_HOME:-~/.local/share}/zsh

# paths

typeset -U path

if [[ $LINUX ]]; then

  path=(
    ~/.local/bin
    ~/.local/share/go/bin
    ~/.local/share/npm/bin
    ~/.gem/ruby/2.7.0/bin
    $path[@]
  )

fi

if [[ $MAC ]]; then

  path=(
    /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/gnu-sed/libexec/gnubin
    /usr/local/opt/grep/libexec/gnubin
    /usr/local/opt/curl/bin
    /usr/local/opt/ncurses/bin
    ~/.local/share/go/bin
    ~/.local/share/npm/bin
    ~/.dotnet/tools
    ~/.gem/ruby/2.6.0/bin
    ~/Library/Python/3.7/bin
    $path[@]
  )

fi

# terminal

zstyle ':prezto:module:terminal' auto-title 'yes'

function palette {
   for color in {0..15}; do
     print -Pn "%K{$color}  %k%F{$color}${(l:2::0:)color}%f "
   done
   print '\n'
}

# theme

export MY_THEME='solarized-light'

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

zinit ice lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice nocompile lucid \
  atload"source ./zsh/$MY_THEME.sh" \
  atload"fast-theme ./fast-syntax-highlighting/$MY_THEME.ini --quiet"
zinit light GrzegorzKozub/themes # after zsh-vim-mode and fast-syntax-highlighting

zinit ice depth=1
zinit light romkatv/powerlevel10k

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

stty -ixon # disable flow control (^s and ^c)

export EDITOR='nvim'
[[ $MAC ]] && export LC_ALL=en_US.UTF-8

# colors

autoload -U colors && colors

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

# prompt

autoload -Uz promptinit && promptinit
setopt prompt_subst

# completion

WORDCHARS=''

if [[ $MAC ]]; then

  typeset -U fpath
  fpath=(
    /usr/local/share/zsh/site-functions
    $fpath[@]
  )

fi

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

# up and down history completion

autoload -U up-line-or-beginning-search down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

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

[[ $LINUX ]] && alias clip='xclip -selection clipboard'
alias diff='diff --color'
alias glances='glances --theme-white'
alias grep='grep --color=auto --exclude-dir={.git}'
alias la='ls -lAh'
alias less='less --raw-control-chars'
alias ls='ls --color=auto'
[[ $MAC ]] && alias pip='pip3'
alias vim='nvim'

# dirhistory

() {
  if [[ $MAC ]]; then local alt='^[^[['; else local alt='^[[1;3'; fi

  bindkey -M vicmd "${alt}D" dirhistory_zle_dirhistory_back
  bindkey -M vicmd "${alt}C" dirhistory_zle_dirhistory_future
  bindkey -M vicmd "${alt}A" dirhistory_zle_dirhistory_up
  bindkey -M vicmd "${alt}B" dirhistory_zle_dirhistory_down
}

# my-cd

my-redraw-prompt() {
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
  BUFFER='git checkout -b ch'
  zle vi-end-of-line
  zle vi-insert
}
zle -N my-git-checkout-branch

bindkey -M vicmd '\egcb' my-git-checkout-branch
bindkey -M viins '\egcb' my-git-checkout-branch

# my-git-commit

function my-git-commit {
  BUFFER='git commit -m "[ch] "'
  zle vi-end-of-line
  zle vi-backward-word
  zle vi-backward-word
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

[[ -f ~/.local/bin/aws_zsh_completer.sh ]] && source ~/.local/bin/aws_zsh_completer.sh

# dotnet

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# elixir

export ERL_AFLAGS='-kernel shell_history enabled'
export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex

alias iex="iex --dot-iex ${XDG_CONFIG_HOME:-~/.config}/iex/iex.exs"

# fzf

export FZF_DEFAULT_OPTS="
  --color dark,bg+:-1,fg:$MY_FZF_COLOR_LIGHT,fg+:-1,hl:$MY_FZF_COLOR_ACCENT,hl+:$MY_FZF_COLOR_ACCENT
  --color spinner:-1,info:-1,prompt:$MY_FZF_COLOR_ACCENT,pointer:$MY_FZF_COLOR_DARK,marker:$MY_FZF_COLOR_DARK
  --layout reverse-list
  --margin 0,0,0,0
  --marker $MY_FZF_CHAR_MARKER
  --no-bold
  --no-info
  --pointer $MY_FZF_CHAR_POINTER
  --prompt $MY_FZF_CHAR_PROMPT
  --tabstop 2
"

bindkey -M vicmd '^[c' fzf-cd-widget
bindkey -M vicmd '^r' fzf-history-widget
bindkey -M vicmd '^t' fzf-file-widget

# gnome

if [[ $LINUX ]]; then

  function fix-gnome-terminal {
    local profile="/org/gnome/terminal/legacy/profiles:/:${"$(gsettings get org.gnome.Terminal.ProfilesList default)":1:-1}"
    case $MY_THEME in
      'solarized-light')
        dconf write "$profile/foreground-color" "'rgb(101,123,131)'"
        dconf write "$profile/background-color" "'rgb(253,246,227)'"
        ;;
      'solarized-dark')
        dconf write "$profile/foreground-color" "'rgb(131,148,150)'"
        dconf write "$profile/background-color" "'rgb(0,43,54)'"
        ;;
    esac
  }

  function fonts {
    if [[ $1 ]]; then
      gsettings set org.gnome.desktop.interface text-scaling-factor $1
    else
      gsettings get org.gnome.desktop.interface text-scaling-factor
    fi
  }

  # https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/1180
  gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch']"
  gsettings set org.gnome.desktop.input-sources xkb-options "[]"

fi

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

export PM2_HOME=${XDG_DATA_HOME:-~/.local/share}/pm2

export NG_CLI_ANALYTICS=ci

# python

export PYLINTHOME=${XDG_CACHE_HOME:-~/.cache}/pylint

# ripgrep

export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME:-~/.config}/ripgrep/ripgreprc

# tmux

alias tmux="tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf"

# vim

export VIMINIT='let $MYVIMRC="'${XDG_CONFIG_HOME:-~/.config}'/vim/vimrc" | source $MYVIMRC'

# zsh-vim-mode

MODE_CURSOR_VIINS='blinking bar'
MODE_CURSOR_VICMD='blinking block'
MODE_CURSOR_VISUAL=$MODE_CURSOR_VICMD
MODE_CURSOR_VLINE=$MODE_CURSOR_VISUAL
MODE_CURSOR_REPLACE=$MODE_CURSOR_VIINS
MODE_CURSOR_SEARCH='steady underline'

# powerlevel10k

[[ -f ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh ]] && source ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh

# cleanup

unset LINUX MAC

