#!/usr/bin/env sh
#
# Git configuration installer
# Usage: ./git-install.sh
# Creates ~/.gitconfig that includes dotfiles/git/gitconfig
#
touch ~/.gitconfig
printf "\
[include]
    path = dotfiles/git/gitconfig
" >> ~/.gitconfig
