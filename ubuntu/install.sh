#! /bin/bash

THIS_DIR=$(dirname "$1")
DOTFILES_DIR=$HOME/.dotfiles
BIN_DIR=$HOME/bin

rm -r $DOTFILES_DIR
cp -r $THIS_DIR/dotfiles $DOTFILES_DIR

for file in $(find $DOTFILES_DIR -maxdepth 1 -type f -printf "%f"); do
    ln -s $DOTFILES_DIR/$file $HOME/$file
done
