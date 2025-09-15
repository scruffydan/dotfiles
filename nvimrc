" Enable Line Numbers
set nu

" Vim-Plug
call plug#begin()
" Install theme and theme related plugins 
Plug 'scruffydan/submonokai-vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'

" Setup fuzzy finder (fzf) 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Setup <C-p> fzf shortcut
nnoremap <C-p> :FZF<CR>

" Setup Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Setup coc.nvim
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Plug 'Yggdroot/indentLine'

call plug#end()

" Setup Theme
syntax on
colorscheme submonokai


" Set tab as 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Command to make :T2 and T4 set tab widths respectively
command T2 :set tabstop=2 | set softtabstop=2 | set shiftwidth=2 | set expandtab"
command T4 :set tabstop=4 | set softtabstop=4 | set shiftwidth=4 | set expandtab"

" Set text wrapping behaviour
set wrap linebreak nolist
set breakindent

" Set enable truecolor
"set termguicolors
" Set background color to transparent
"hi NORMAL ctermbg=NONE

" Prevent cursor from changing when switching modes
set guicursor=

" Allow saving of files as sudo when I forgot to start vim using sudo.
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Required for operations modifying multiple buffers like rename.
set hidden

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" Show Invisible characters
set listchars=eol:¬,tab:>·,trail:·,extends:>,precedes:<
set list

" Dont conceal characters
set conceallevel=0


