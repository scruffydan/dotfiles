" Enable Line Numbers
set nu

" Vim-Plug
call plug#begin()
Plug 'scruffydan/submonokai-vim'
Plug 'pangloss/vim-javascript'

" Setup fuzzy finder (fzf) 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Setup <C-p> fzf shortcut
nnoremap <C-p> :FZF<CR>

call plug#end()

" Setup Theme
syntax on
colorscheme submonokai

" Set enabale truecolor
"set termguicolors
" Set background color to transparent
"hi NORMAL ctermbg=NONE

" Pervent cursor from changing when switching modes
set guicursor=
