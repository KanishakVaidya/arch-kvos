echo "setting a link to doas"
doas ln -sf /bin/doas /bin/sudo
echo "setting a link to xresources"
ln -sf ~/.config/Xresources/codedark ~/.Xresources
mkdir -p $HOME/desktop $HOME/dwn $HOME/templates $HOME/shared $HOME/doc $HOME/music $HOME/pic $HOME/vid $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin
doas pacman --noconfirm -S xdg-user-dirs rsync
xdg-user-dirs-update

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

#!/bin/bash

echo "
#######################
Installing the packages
#######################
"

doas pacman --needed -Syu $(cat packages.txt)
