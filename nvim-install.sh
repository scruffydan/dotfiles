#!/bin/sh

# Setup neovim config file 
mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim;
printf "source ~/dotfiles/nvimrc" >> ~/.config/nvim/init.vim;
