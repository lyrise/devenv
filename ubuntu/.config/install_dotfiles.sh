#!/bin/zsh

cd $(dirname $0)
current_dir=$(pwd)
dotfiles_dir=$HOME/.dotfiles

rm -r $dotfiles_dir
cp -r $current_dir/dotfiles $dotfiles_dir

cd $dotfiles_dir

ignore_names=("." "..")
for dotfile_name in .?*; do
    is_ignored=0
    for ignore_name in ${ignore_names[@]}; do
        if [ $dotfile_name = $ignore_name ]; then
            is_ignored=1
            break
        fi
    done

    if [ $is_ignored -ne 1 ]; then
        ln -s -v -f "$dotfiles_dir/$dotfile_name" $HOME
    fi
done
