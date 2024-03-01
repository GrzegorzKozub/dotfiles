#!/usr/bin/env zsh

set -o verbose

# gpg

export GNUPGHOME=$XDG_DATA_HOME/gnupg

[[ -d $GNUPGHOME ]] && rm -rf $GNUPGHOME
mkdir $GNUPGHOME && chmod 700 $GNUPGHOME

gpg2 --batch --passphrase '' --quick-gen-key grzegorz.kozub@gmail.com

# pass

export PASSWORD_STORE_DIR=$XDG_DATA_HOME/pass

[[ -d $PASSWORD_STORE_DIR ]] && rm -rf $PASSWORD_STORE_DIR

pass init grzegorz.kozub@gmail.com

