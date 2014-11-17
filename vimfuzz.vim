set nocp
set autoindent
set nojoinspaces
set sw=4 ts=4 sts=4 expandtab
edit /tmp/vimfuzz/input.txt

let i = 1
for line in readfile('/tmp/vimfuzz/commands.txt')
    " echo line
    execute 'normal! ' . substitute(line, '<Esc>', "\<Esc>", '')
    let fname = printf('/tmp/vimfuzz/output-%03d.txt', i)
    execute 'write ' . fname
    let i = i + 1
endfor
quit!
