set tabstop=8
set softtabstop=8
set noexpandtab

"set shiftwidth=8
"set expandtab

"set colorcolumn=81
"highlight ColorColumn ctermbg=darkgrey
set textwidth=96
"set wrapmargin=80

"set showbreak=""
"set wrap
"set cpo=n

"au BufWinEnter * if &textwidth > 8
"\ | let w:m1=matchadd('MatchParen', printf('\%%<%dv.\%%>%dv', &textwidth+1, &textwidth-8), -1)
"\ | let w:m2=matchadd('ErrorMsg', printf('\%%>%dv.\+', &textwidth), -1)
"\ | endif

au BufWinEnter *
\ | let w:m1=matchadd('ErrorMsg', printf('\%%>%dv.\+', 96))

set ruler
"set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %)
"set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set laststatus=2 "black status line at bottom of window
if has("win32")
  set statusline=%<%f%h%m%r%=%{strftime(\"%I:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}\ %{&ff}\ %l,%c%V\ %P
else
" set statusline=%<%f%h%m%r%=%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}\ %{&ff}\ %l,%c%V\ %P
  set statusline=%<%f%h%m%r%=%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}\ %{&ff}\ %l,%c%V\ 
endif

set paste
"set viminfo='0,:0,<0,@0,f0

nmap <F4> :q <CR>
"nmap <F2> :set ruler <CR>

"vmap <C-s-x> "+x
"vmap <C-s-c> "+y
"vmap <C-s-v> <Esc>"+gP

"map  --> insert+normal+operator-pending mapping
"imap --> insert mode mapping
"nmap --> normal mode mapping
"omap --> operator-pending mapping
"cmap --> command-line mapping
"vmap --> visual+select mode mapping
"xmap --> visual mode mapping
"smap --> select mode mapping

"set number

"set exrc
"set secure
