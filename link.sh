#!/bin/zsh

CONFIG_DIR=$HOME/.config

ln -f .zshrc $HOME
ln -f .vimrc $HOME

mkdir -p $CONFIG_DIR
ln -f starship.toml $CONFIG_DIR

mkdir -p $CONFIG_DIR/kak
ln -f kakrc $CONFIG_DIR/kak

echo "Linked dotfiles."
