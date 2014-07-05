#!/bin/sh

# Set up `.gitconfig` file. Appends source `~/dotfile/zsh/env`
printf "
[include]
    path = dotfiles/git/gitconfig
" >> ~/.gitconfig;