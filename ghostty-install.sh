#!/usr/bin/env sh
mkdir -p ~/.config/ghostty;
touch ~/.config/ghostty/config;
printf "
# Source my default config
config-file = ~/dotfiles/ghostty
" >> ~/.config/ghostty/config 
