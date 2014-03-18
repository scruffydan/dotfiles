#!/bin/bash

# Set up .zshenv file. Appends source ~/dotfile/zsh/env
printf "
if [ -f ~/dotfiles/zsh/env ]; then
    source ~/dotfiles/zsh/env
fi
" >> ~/.zshenv;

# Set up .zshrc file. Appends source ~/dotfile/zshrc
printf "
if [ -f ~/dotfiles/zshrc ]; then
    source ~/dotfiles/zshrc
fi
" >> ~/.zshrc;

# Make login shells opperate like interactive shells Appends source ~/.zshrc
printf "
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi
" >> ~/.zlogin;

# Set up .zshrc file. Appends source ~/dotfile/zshrc
printf "
if [ -f ~/dotfiles/zsh/logout ]; then
    source ~/dotfiles/zsh/logout
fi
" >> ~/.zlogout;

zsh;