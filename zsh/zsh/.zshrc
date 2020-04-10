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

# theme

export MY_THEME='solarized-light'

# plugins

export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-~/.cache}/zinit

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

export EDITOR='vim'
[[ $MAC ]] && export LC_ALL=en_US.UTF-8

# colors

autoload -U colors && colors

if [[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )); then
  COLORS_FILE=${XDG_CACHE_HOME:-~/.cache}/zsh/dir_colors
  if [[ ! -f $COLORS_FILE ]]; then
    dircolors --print-database > $COLORS_FILE
    sed -i 's/ 01;/ 00;/' $COLORS_FILE
    sed -i 's/;01 /;00 /' $COLORS_FILE
  fi
  eval `dircolors -b $COLORS_FILE`
  unset COLORS_FILE
fi

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

backup-history() {
  if [[ -d $(dirname $1) ]]; then
    if [[ ! -f $HISTFILE ]]; then touch $HISTFILE; fi
    if [[ ! -f $1 ]]; then touch $1; fi
    if [[ $(stat -c%s $HISTFILE) -gt $(stat -c%s $1) ]]; then
      cp $HISTFILE $1
    else
      cp $1 $HISTFILE
    fi
  fi
}

backup-history ~/code/backups/.zshhist

# aliases

[[ $LINUX ]] && alias clip='xclip -selection clipboard'
alias diff='diff --color'
alias glances='glances --theme-white'
alias grep='grep --color=auto --exclude-dir={.git}'
alias la='ls -lAh'
alias ls='ls --color=auto'
[[ $MAC ]] && alias pip='pip3'

# dirhistory

if [[ $MAC ]]; then ALT='^[^[['; else ALT='^[[1;3'; fi

bindkey -M vicmd "${ALT}D" dirhistory_zle_dirhistory_back
bindkey -M vicmd "${ALT}C" dirhistory_zle_dirhistory_future
bindkey -M vicmd "${ALT}A" dirhistory_zle_dirhistory_up
bindkey -M vicmd "${ALT}B" dirhistory_zle_dirhistory_down

unset ALT

# aws

export AWS_CONFIG_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/config
export AWS_SHARED_CREDENTIALS_FILE=${XDG_CONFIG_HOME:-~/.config}/aws/credentials
export AWS_PROFILE=greg

# dotnet

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# elixir

export ERL_AFLAGS='-kernel shell_history enabled'
export HEX_HOME=${XDG_CACHE_HOME:-~/.cache}/hex

alias iex="iex --dot-iex ${XDG_CONFIG_HOME:-~/.config}/iex/iex.exs"

# fzf

bindkey -M vicmd '^[c' fzf-cd-widget
bindkey -M vicmd '^r' fzf-history-widget
bindkey -M vicmd '^t' fzf-file-widget

# gnome

if [[ $LINUX ]]; then

  set-gnome-terminal-colors() {
    [[ $TERM_PROGRAM == 'vscode' ]] && return
    [[ ! $+commands[gsettings] || ! $+commands[dconf] ]] && return
    PROFILE="/org/gnome/terminal/legacy/profiles:/:${"$(gsettings get org.gnome.Terminal.ProfilesList default)":1:-1}"
    case $MY_THEME in
      'solarized-light')
        dconf write "$PROFILE/foreground-color" "'rgb(101,123,131)'"
        dconf write "$PROFILE/background-color" "'rgb(253,246,227)'"
        ;;
      'solarized-dark')
        dconf write "$PROFILE/foreground-color" "'rgb(131,148,150)'"
        dconf write "$PROFILE/background-color" "'rgb(0,43,54)'"
        ;;
    esac
    unset PROFILE
  }

  set-gnome-terminal-colors

  function fonts {
    if (( ${+1} )); then
      gsettings set org.gnome.desktop.interface text-scaling-factor $1
    else
      gsettings get org.gnome.desktop.interface text-scaling-factor
    fi
  }

fi

# gnupg

export GNUPGHOME=${XDG_DATA_HOME:-~/.local/share}/gnupg

# less

export LESSHISTFILE=-

# node

export NG_CLI_ANALYTICS=ci
export NPM_CONFIG_CACHE=${XDG_CACHE_HOME:-~/.cache}/npm
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-~/.local/share}/npm
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME:-~/.config}/npm/npmrc

# ranger

function ranger-cd {
  TEMP_FILE="$(mktemp)"
  ranger --choosedir="$TEMP_FILE" "$@" < $TTY
  if [ -f "$TEMP_FILE" ]; then
    TARGET_DIR="$(cat "$TEMP_FILE")"
    rm -f "$TEMP_FILE"
    [ -d "$TARGET_DIR" ] && [ "$TARGET_DIR" != "$(pwd)" ] && cd "$TARGET_DIR"
    unset TARGET_DIR
  fi
  unset TEMP_FILE
  zle reset-prompt
}

zle -N ranger-cd
bindkey -M vicmd '\er' ranger-cd
bindkey -M viins '\er' ranger-cd

# tmux

alias tmux="tmux -f ${XDG_CONFIG_HOME:-~/.config}/tmux/tmux.conf"

# vim

export VIMINIT='let $MYVIMRC="'${XDG_CONFIG_HOME:-~/.config}'/vim/vimrc" | source $MYVIMRC'

# zsh-vim-mode

# MODE_CURSOR_SEARCH='steady block'
# MODE_CURSOR_VICMD='blinking block'
# MODE_CURSOR_VIINS='blinking bar'

# powerlevel10k

[[ ! -f ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh ]] || source ${XDG_CONFIG_HOME:-~/.config}/zsh/.p10k.zsh

# cleanup

unset LINUX MAC

