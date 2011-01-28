" Window size
"set winwidth=85
"let g:halfsize=86
"let g:fullsize=171
"set lines=70
"let &columns=g:halfsize

" Font
set guifont=Menlo:h13.00

" numbers, we like them
set number

" Use console dialogs
set guioptions+=c

" turn off side scrollbar
set go-=L

" turn off gui icon bar
set go-=T

" tab labels
set guitablabel=%t

" add a cursorline
set cursorline

set colorcolumn=80

colorscheme ir_black

" w00t
set bg=dark
if &background == "dark"
    set transparency=5
endif
