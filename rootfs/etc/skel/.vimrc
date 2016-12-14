set exrc
set secure

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set colorcolumn=110
highlight ColorColumn ctermbg=darkgrey

set paste
set viminfo='0,:0,<0,@0,f0

nmap <F4> :q <CR>

vmap <C-s-x> "+x
vmap <C-s-c> "+y
vmap <C-s-v> <Esc>"+gP

"map  --> insert+normal+operator-pending mapping
"imap --> insert mode mapping
"nmap --> normal mode mapping
"omap --> operator-pending mapping
"cmap --> command-line mapping
"vmap --> visual+select mode mapping
"xmap --> visual mode mapping
"smap --> select mode mapping

"set number
