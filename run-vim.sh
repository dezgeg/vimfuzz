#!/bin/bash
cd "$(dirname "$0")"
rm -rf /tmp/vimfuzz
mkdir -p /tmp/vimfuzz
cat file-to-test.txt file-to-test.txt > /tmp/vimfuzz/input.txt

for i in $(seq 1 99); do
    tag=$(printf "%05d" $i)
    ./generate.rb $i > /tmp/vimfuzz/commands.txt
    vim -u NONE -S vimfuzz.vim
    cat -v /tmp/vimfuzz/errors.txt | \
        grep -v 'written$' | grep -v '^"/tmp/vimfuzz/' | \
        grep -v 'fewer lines' | \
        grep -v '>ed .* time' | \
        grep -v '<ed .* time' | \
        egrep -v '^\s*$'
    mv /tmp/vimfuzz/commands.txt /tmp/vimfuzz/commands-$tag.txt
    perl-rename "s/output/vim-$tag/" /tmp/vimfuzz/output*.txt
done
