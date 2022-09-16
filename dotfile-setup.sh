mkdir -p $HOME/desktop $HOME/dwn $HOME/templates $HOME/shared $HOME/doc $HOME/music $HOME/pic $HOME/vid $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

echo "setting a link to xresources"
ln -sf ~/.config/Xresources/codedark ~/.Xresources
doas pacman --noconfirm -S xdg-user-dirs
xdg-user-dirs-update

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -c PlugInstall

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

#!/bin/bash

while [[ $installpkgs != 'y' ]]
do
   clear
   echo "#######################"
   echo "Installing the packages"
   echo "#######################"

   nvim packages.md
   awk '/\- \[X\]/ {getline ; print}' packages.md | tr "\n" " " > /tmp/packages.txt
   echo -e "Following packages will be installed:"
   cat /tmp/packages.txt
   read -p "Do you want to proceed (y/n): " installpkgs
done


noerror='n'
while [[ $noerror != 'y'  ]]
do
    doas pacman --needed -Syu $(cat /tmp/packages.txt)
    read -p "Installation ended successfully? (y/n): " noerror
done
