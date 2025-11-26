#!/usr/bin/env sh

# Set up `.zshenv` file. Appends source `~/dotfile/zsh/env`
printf "
if [[ -a ~/dotfiles/zsh/env ]]; then
    source ~/dotfiles/zsh/env
fi
" >> ~/.zshenv;

# Set up `.zshrc` file. Appends source `~/dotfile/zshrc`
printf "
if [[ -a ~/dotfiles/zshrc ]]; then
    source ~/dotfiles/zshrc
fi
" >> ~/.zshrc;

zsh;