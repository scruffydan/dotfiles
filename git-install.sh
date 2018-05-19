#!/bin/sh

# Setup `.gitconfig` file. Appends source `~/.gitconfig
touch ~/.gitconfig;
printf "
[include]
    path = dotfiles/git/gitconfig
" >> ~/.gitconfig;
