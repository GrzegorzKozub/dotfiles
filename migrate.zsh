#!/usr/bin/env zsh

set -o verbose

# gpg

~/code/keys/init.zsh

# pass

export PASSWORD_STORE_DIR=$XDG_DATA_HOME/pass

[[ -d $PASSWORD_STORE_DIR ]] && rm -rf $PASSWORD_STORE_DIR

pass init grzegorz.kozub@gmail.com

