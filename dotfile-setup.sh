mkdir -p $HOME/desktop $HOME/dwn $HOME/templates $HOME/shared $HOME/doc $HOME/music $HOME/pic/.wall $HOME/vid $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config $HOME/.local/share/AppImages $HOME/.local/share/fonts

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

git clone --depth=1 https://github.com/KanishakVaidya/wallpapers.git $HOME/pic/.wall

echo "setting a link to xresources"
ln -sf $HOME/.config/Xresources/codedark $HOME/.Xresources

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

#!/bin/bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c PlugInstall -c qa
clear
echo "#######################"
echo "Installing the packages"
echo "#######################"

nvim $HOME/packages.md
awk '/\- \[X\]/ {getline ; print}' $HOME/packages.md | tr "\n" " " > /tmp/packages.txt
clear ; echo -e "\n Following packages will be installed: \n"
cat /tmp/packages.txt
echo -e "\n"

noerror='n'
while [[ $noerror != 'y'  ]]
do
    su -c "pacman --needed -Syu $(cat /tmp/packages.txt)" root
    read -p "Installation ended successfully? (y/n): " noerror
done
xdg-user-dirs-update
fc-cache -fv
echo "Now you can restart the system. Log into your account and start the session using startx command"
