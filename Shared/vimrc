syntax on
set number
:imap jj <ESC>
nmap <S-Enter> O<Esc>
nmap <Enter> o<Esc>
let mapleader = "\<Space>"

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
autocmd BufWritePre     *.rb :call TrimWhiteSpace()
autocmd BufWritePre	*.c :call TrimWhiteSpace()
autocmd BufWritePre	*.cpp :call TrimWhiteSpace()
autocmd BufWritePre	*.h :call TrimWhiteSpace()

filetype plugin indent on
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
