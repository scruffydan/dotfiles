#!/usr/bin/env sh
#
# Tmux configuration installer
# Usage: ./tmux-install.sh
# Creates ~/.tmux.conf that sources ~/dotfiles/tmux.conf
#
touch ~/.tmux.conf
printf "\
source-file ~/dotfiles/tmux.conf
" >> ~/.tmux.conf