# Use plug.kak to manage plugins
source "%val{config}/plugins/plug.kak/rc/plug.kak"

# Setup smarttab.kak
plug "andreyorst/smarttab.kak" defer smarttab %{
    # When `backspace' is pressed, 4 spaces are deleted at once
    set-option global softtabstop 4
} config %{
    hook global WinSetOption filetype=(kak) expandtab
    hook global WinSetOption filetype=(c|cpp) smarttab
}

# Use kakoune-edit-or-dir to add file tree
plug "TeddyDD/kakoune-edit-or-dir"
# Alias edit-or-dir to :e
unalias global e edit
alias global e edit-or-dir

# Use kakoune-mark to highlight words
plug "https://gitlab.com/fsub/kakoune-mark"
# Bind mark to m and unmark to M
map global user m :mark-word<ret>
map global user M :mark-clean<ret>

# Add line numbers
add-highlighter global/ number-lines -relative -hlcursor

# jj in order to exit insert mode
hook global InsertChar j %{ try %{
    exec -draft hH <a-k>jj<ret> d
    exec <esc>
}}

# Remove trailing whitespace
hook global BufWritePre .* %{ try %{ execute-keys -draft \%s\h+$<ret>d } }

# Allow usage of tab to execute completion while in insert mode
hook global InsertCompletionShow .* %{
    try %{
        exec -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

# Use four spaces for c/cpp/h files
hook global WinSetOption filetype=(c|cpp|cc|cxx|C|h|hh|hpp|hxx|H) %{
    set global tabstop 4
    set global indentwidth 4
}

# Copy goes to clipboard
hook global NormalKey y|d|c %{ nop %sh{
    printf %s "$kak_main_reg_dquote" | pbcopy
}}

# Paste from clipboard
map global user P '!pbpaste<ret>'
map global user p '<a-!>pbpaste<ret>'
