" Enable Line Numbers
set nu

" Vim-Plug
call plug#begin()
Plug 'ErichDonGubler/vim-sublime-monokai'
Plug 'pangloss/vim-javascript'
call plug#end()

" Setup Theme
syntax on
colorscheme sublimemonokai
hi NORMAL guibg=NONE ctermbg=NONE
hi LineNr guibg=#211F1C ctermbg=233
hi LineNr guifg=#e6db74 ctermfg=186
set cursorline
hi CursorLine guibg=NONE ctermbg=NONE
set guicursor=
