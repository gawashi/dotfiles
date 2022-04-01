#!/bin/bash

BASEDIR=$(dirname $0)
cd $BASEDIR

for file in .??*
do
    # ignore files
    [[ "$file" == ".git" ]] && continue
    [[ "$file" == ".gitignore" ]] && continue
    [[ "$file" == ".DS_Store" ]] && continue

    # synbolic link
    echo "$file"
    ln -sf $PWD/$file ~
done
