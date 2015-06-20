#!/bin/sh

# Set up `.gitconfig` file. Appends source `~/.gitconfig
touch ~/.gitconfig;
printf "
[include]
    path = dotfiles/git/gitconfig
" >> ~/.gitconfig;