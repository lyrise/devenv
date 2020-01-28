#!/bin/zsh

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

(cd $SCRIPT_DIR/.config && sh install_apps.sh && sh install_dotfiles.sh)
