" Enable Line Numbers
set nu

" Vim-Plug
call plug#begin()
" Install theme and theme related plugins 
Plug 'scruffydan/submonokai-vim'
Plug 'pangloss/vim-javascript'

" Setup fuzzy finder (fzf) 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Setup <C-p> fzf shortcut
nnoremap <C-p> :FZF<CR>

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" close preview window on leaving the insert mode
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

Plug 'Yggdroot/indentLine'

call plug#end()

" Setup Theme
syntax on
colorscheme submonokai

" Set tab as 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Set text wrapping behaviour
set wrap linebreak nolist

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

" Setup Language Servers
"Language Servers are listed here
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'html': ['html-languageserver', '--stdio'],
    \ 'css': ['css-languageserver', '--stdio'],
    \ 'sass': ['css-languageserver', '--stdio'],
    \ 'scss': ['css-languageserver', '--stdio'],
    \ }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
