set nocompatible
set number
set nobackup
set noswapfile
set vb t_vb=
set autoindent
set scrolloff=8
set backspace=indent,eol,start
set splitbelow

syntax on
filetype plugin indent on

augroup run_on_start
    autocmd!
    " for xml files, 2 spaces
    autocmd Filetype xml setlocal ts=2 sw=2 expandtab

    " for html/js/java files, 4 spaces
    autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
    autocmd Filetype html,jsp setlocal ts=4 sw=4 expandtab
    autocmd Filetype xml setlocal ts=2 sw=2 expandtab
    autocmd Filetype java setlocal ts=4 sw=4 sts=0 expandtab

    " put curson where left
    autocmd BufReadPost *
                            \ if line("'\"") > 1 && line("'\"") <= line("$") |
                            \   exe "normal! g`\"" |
                            \ endif
augroup END

map Q gq

let mapleader = " "
nnoremap <Leader>v <C-v>

nnoremap <C-j> 3j
nnoremap <C-k> 3k
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <C-l> :buffers<CR>:buffer
nnoremap <F9> :!cls && echo "target : exec" && echo. && mvn -quiet exec:java<CR>
nnoremap <F8> :!cls && echo "target : clean compile exec" && echo. && mvn -quiet clean compile exec:java<CR>
nnoremap <leader>t :terminal<cr>

vnoremap y "+y
