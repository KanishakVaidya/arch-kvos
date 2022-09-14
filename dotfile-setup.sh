#!/bin/bash

echo "
#######################
Installing the packages
#######################
"

doas pacman -Syu $(cat packages.txt)

git clone --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/
rm -r /tmp/tmpdotfiles
