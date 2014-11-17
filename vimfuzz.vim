set nocp
set autoindent
set nojoinspaces
set sw=4 ts=4 sts=4 expandtab
edit /tmp/vimfuzz/input.txt
redir! > /tmp/vimfuzz/errors.txt

let i = 1
for line in readfile('/tmp/vimfuzz/commands.txt')
    " echo line
    let unevaled = '"' . substitute(substitute(line, '"', '\\"', 'g'), '<', '\\<', 'g') . '"'
    " echo i . ' unevaled: ' . unevaled
    let evaled = eval(unevaled)
    " echo i . ' evaled  : ' . evaled
    execute 'normal! ' . evaled
    let fname = printf('/tmp/vimfuzz/output-%03d.txt', i)
    execute 'write ' . fname
    let i = i + 1
endfor
quit!
