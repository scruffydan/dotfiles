#!/usr/bin/env sh
#
# Ghostty terminal configuration installer
# Usage: ./ghostty-install.sh
# Creates ~/.config/ghostty/config that sources ~/dotfiles/ghostty
#
mkdir -p ~/.config/ghostty
touch ~/.config/ghostty/config
printf "\
# Source my default config
config-file = ~/dotfiles/ghostty
" >> ~/.config/ghostty/config 
