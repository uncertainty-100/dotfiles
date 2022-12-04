#!/usr/bin/bash

dot_file_dir=~/.dotfiles
date=$(date --rfc-3339=seconds -u | sed 's/\s/_/g')

for file in $(find $dot_file_dir/home -type f); do
    # path of the file without the "/home/user" part at the start
    file_name=$(echo $file | sed "s/$(echo "$dot_file_dir/home/" | sed 's/\//\\\//g')//")

    if [[ -f $HOME/$file_name ]]; then #file exists
        if [[ -L $HOME/$file_name ]]; then #file is link
            if [[ $(readlink $HOME/$file) == $file ]]; then continue; fi
            unlink $HOME/$file_name
            ln -s $file $HOME/$file_name
        else
            mkdir -p $(dirname $dot_file_dir/backup/$date/$file_name)
            mv $HOME/$file_name $dot_file_dir/backup/$date/$file_name
            ln -s $file $HOME/$file_name
        fi
    else
        mkdir -p $(dirname $HOME/$file_name)
        ln -s $file $HOME/$file_name
    fi
done



