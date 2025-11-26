#!/usr/bin/env sh

# Set up `.gitconfig` file. Appends source `~/.gitconfig
touch ~/.tmux.conf;
printf "
source-file ~/dotfiles/tmux.conf
" >> ~/.tmux.conf;