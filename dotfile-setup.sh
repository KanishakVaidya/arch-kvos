mkdir -p $HOME/desktop $HOME/dwn $HOME/templates $HOME/shared $HOME/doc $HOME/music $HOME/pic/.wall $HOME/vid $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

echo "setting a link to xresources"
ln -sf ~/.config/Xresources/codedark ~/.Xresources

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

#!/bin/bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
while [[ $installpkgs != 'y' ]]
do
   clear
   echo "#######################"
   echo "Installing the packages"
   echo "#######################"

   nvim -c PlugInstall packages.md
   awk '/\- \[X\]/ {getline ; print}' packages.md | tr "\n" " " > /tmp/packages.txt
   clear ; echo -e "Following packages will be installed:"
   cat /tmp/packages.txt
   read -p "Do you want to proceed (y/n): " installpkgs
done


noerror='n'
while [[ $noerror != 'y'  ]]
do
    doas pacman --needed --noconfirm -Syu $(cat /tmp/packages.txt)
    xdg-user-dirs-update
    read -p "Installation ended successfully? (y/n): " noerror
done
