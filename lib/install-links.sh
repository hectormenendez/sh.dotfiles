#!/usr/bin/env bash
set -e

_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $_path/utils.sh

for dotfile in $(dotfiles $DOTFILES_SRC); do
    BACKUP=false

    dotfile_path=~/.$dotfile

    # Detect if there's a file already there and take action on i.
    if [[ -e $dotfile_path ]]; then

        # is it a symlink pointing to this dotfiles? skip it
        if [ -L $dotfile_path -a $(getLinkPath $dotfile_path) = "$DOTFILES_SRC" ]; then
            echo "Skipping, already linked: $dotfile"
            continue
        fi

        # ok, dotfile is not ours, back it up & move it out
        mv $dotfile_path $dotfile_path.bak
        BACKUP=true
    fi

    # create the symlink, but be relative about it.
    cd $HOME
    ln -s ${DOTFILES_SRC/$HOME\//}/$dotfile ./.$dotfile

    # OCT is my burden
    isDarwin  && /bin/chmod -h 750 ./.$dotfile

    printf "Symlinked $dotfile. "
    $BACKUP &&  printf "[foreign dotfile detected, backed it up]"
    echo
done
