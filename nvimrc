" Enable Line Numbers
set nu

" Vim-Plug
call plug#begin()
Plug 'scruffydan/submonokai-vim'
Plug 'pangloss/vim-javascript'
call plug#end()

" Setup Theme
syntax on
colorscheme submonokai

" Set enabale truecolor
"set termguicolors
" Set background color to transparent
"hi NORMAL ctermbg=NONE

" Allow Custom color for cursor line
set cursorline
" Pervent cursor from changing when switching modes
set guicursor=
