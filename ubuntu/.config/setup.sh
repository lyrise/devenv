#!/bin/zsh

cd $(dirname $0)
current_dir=$(pwd)

(cd $current_dir && zsh install_apps.sh)
(cd $current_dir && zsh install_dotfiles.sh)
