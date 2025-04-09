set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

set number
set ruler
set showmode
set showcmd
set clipboard+=unnamed
set incsearch
set hlsearch
vmap '' :w !pbcopy<CR><CR>
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'
