#!/usr/bin/env sh

# Setup neovim config file
mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim;
printf "source ~/dotfiles/nvimrc" >> ~/.config/nvim/init.vim;

# Setup vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
