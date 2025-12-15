#!/usr/bin/env sh
#
# Neovim configuration installer
# Usage: ./nvim-install.sh
# Creates ~/.config/nvim/init.lua that sources ~/dotfiles/nvim/init.lua
#
mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.lua
printf "dofile(vim.fn.expand('~/dotfiles/nvim/init.lua'))" >> ~/.config/nvim/init.lua
