#!/usr/bin/env sh

# Setup neovim config file
mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.lua;
printf "dofile(vim.fn.expand('~/dotfiles/nvim/init.lua'))" >> ~/.config/nvim/init.lua;
