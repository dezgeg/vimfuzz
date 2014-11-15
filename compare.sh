#!/bin/bash
cd "$(dirname "$0")"

for i in $(seq 1 99999); do
    for j in $(seq 1 99999); do
        suffix=$(printf "%05d-%03d.txt" $i $j)
        if [ ! -f "/tmp/vimfuzz/vim-$suffix" ]; then
            break
        fi
        if ! git --no-pager diff --no-index --color "/tmp/vimfuzz/vim-$suffix" "/tmp/vimfuzz/ideavim-$suffix"; then

            cmd=$(cat /tmp/vimfuzz/commands-$(printf "%05d" $i).txt | sed "${j}q;d")
            echo "Failing command: $cmd"
            if [ "$j" != 1 ]; then
                prevcmd=$(cat /tmp/vimfuzz/commands-$(printf "%05d" $i).txt | sed "$((j - 1))q;d")
                echo "Previous command: $prevcmd"
            else
                echo "No previous command!"
            fi

            echo
            echo
            break
        fi
    done
done
