" Window size
"set winwidth=85
"let g:halfsize=86
"let g:fullsize=171
"set lines=70
"let &columns=g:halfsize

" Font
set guifont=Menlo:h13.00

" Use console dialogs
"set guioptions+=c

" turn off side scrollbar
set go-=L

" turn off gui icon bar
set go-=T

" tab labels
set guitablabel=%t

" add a cursorline
set cursorline

"colorscheme ir_black
"colorscheme summerfruit256
set background=light
colorscheme solarized


if has("gui_macvim")
  " mostly via Janus
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
  " set a nice leader command to open in default app on osx
  map <Leader>o :w\|:!open %<CR>
  "command-][ for indentation
  vmap <D-]> >gv
  vmap <D-[> <gv

  " Map Command-# to switch tabs
  map  <D-0> 0gt
  imap <D-0> <Esc>0gt
  map  <D-1> 1gt
  imap <D-1> <Esc>1gt
  map  <D-2> 2gt
  imap <D-2> <Esc>2gt
  map  <D-3> 3gt
  imap <D-3> <Esc>3gt
  map  <D-4> 4gt
  imap <D-4> <Esc>4gt
  map  <D-5> 5gt
  imap <D-5> <Esc>5gt
  map  <D-6> 6gt
  imap <D-6> <Esc>6gt
  map  <D-7> 7gt
  imap <D-7> <Esc>7gt
  map  <D-8> 8gt
  imap <D-8> <Esc>8gt
  map  <D-9> 9gt
  imap <D-9> <Esc>9gt

endif
