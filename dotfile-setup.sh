dotfile_text="
██╗░░██╗██╗░░░██╗░█████╗░░██████╗  ██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░███████╗██████╗░
██║░██╔╝██║░░░██║██╔══██╗██╔════╝  ██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░██╔════╝██╔══██╗
█████═╝░╚██╗░██╔╝██║░░██║╚█████╗░  ██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░█████╗░░██████╔╝
██╔═██╗░░╚████╔╝░██║░░██║░╚═══██╗  ██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░██╔══╝░░██╔══██╗
██║░╚██╗░░╚██╔╝░░╚█████╔╝██████╔╝  ██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗███████╗██║░░██║
╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═════╝░  ╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝╚═╝░░╚═╝
        "
echo $dofile_text

echo "Please grant root priveliges to $USER"
echo "
[kv-arch-repo]
SigLevel = Optional TrustAll
Server = https://kanishakvaidya.github.io/\$repo/\$arch" | sudo tee -a /etc/pacman.conf

curl -fLo /tmp/packages.md https://raw.githubusercontent.com/KanishakVaidya/arch-KVOS/main/packages.md
nvim /tmp/packages.md

noerror='n'
while [[ $noerror != 'y'  ]]
do
    sudo pacman -Syu --needed --noconfirm $(awk '/\- \[X\]/ {getline ; print}' /tmp/packages.md | tr "\n" " " )
    read -p "Installation ended successfully? (y/n): " noerror
done
echo 'export ZDOTDIR="$HOME"/.config/zsh' | sudo tee /etc/zsh/zshenv
chsh -s /usr/bin/zsh

#!/bin/bash
[[ -d $HOME/Desktop ]] && mv $HOME/Desktop $HOME/desktop || mkdir -p $HOME/desktop
[[ -d $HOME/Downloads ]] && mv $HOME/Downloads $HOME/dwn || mkdir -p $HOME/dwn
[[ -d $HOME/Templates ]] && mv $HOME/Templates $HOME/templates || mkdir -p $HOME/templates
[[ -d $HOME/Public ]] && mv $HOME/Public $HOME/shared || mkdir -p $HOME/shared
[[ -d $HOME/Documents ]] && mv $HOME/Documents $HOME/doc || mkdir -p $HOME/doc
[[ -d $HOME/Music ]] && mv $HOME/Music $HOME/music || mkdir -p $HOME/music
[[ -d $HOME/Pictures ]] && mv $HOME/Pictures $HOME/pic || mkdir -p $HOME/pic
[[ -d $HOME/Videos ]] && mv $HOME/Videos $HOME/vid || mkdir -p $HOME/vid
mkdir -p $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config $HOME/.local/share/AppImages $HOME/.local/share/fonts

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

xdg-user-dirs-update
fc-cache -fv

# git clone --depth=1 https://github.com/KanishakVaidya/wallpapers.git $HOME/pic/.wall

echo "setting a link to xresources"
ln -sf $HOME/.config/Xresources/codedark $HOME/.Xresources

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c PlugInstall -c qa
clear

git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
(cd /tmp/paru-bin ; makepkg -si)

echo "
_/\\\\\\________/\\\\\\_____/\\\\\\\\\\\\\\\\\\________/\\\\\\\\\\\\\\\\\\\\\\____/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\\\\____
_\\/\\\\\\_______\\/\\\\\\___/\\\\\\\\\\\\\\\\\\\\\\\\\\____/\\\\\\/////////\\\\\\_\\///////\\\\\\/////____/\\\\\\\\\\\\\\\\\\\\\\\\\\__
__\\/\\\\\\_______\\/\\\\\\__/\\\\\\/////////\\\\\\__\\//\\\\\\______\\///________\\/\\\\\\________/\\\\\\/////////\\\\\\_
___\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_\\/\\\\\\_______\\/\\\\\\___\\////\\\\\\_______________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_
____\\/\\\\\\/////////\\\\\\_\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\______\\////\\\\\\____________\\/\\\\\\_______\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_
_____\\/\\\\\\_______\\/\\\\\\_\\/\\\\\\/////////\\\\\\_________\\////\\\\\\_________\\/\\\\\\_______\\/\\\\\\/////////\\\\\\_
______\\/\\\\\\_______\\/\\\\\\_\\/\\\\\\_______\\/\\\\\\__/\\\\\\______\\//\\\\\\________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_
_______\\/\\\\\\_______\\/\\\\\\_\\/\\\\\\_______\\/\\\\\\_\\///\\\\\\\\\\\\\\\\\\\\\\/_________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_
________\\///________\\///__\\///________\\///____\\///////////___________\\///________\\///________\\///__
______________________________/\\\\\\_________________/\\\\\\\\\\\\\\\\\\________________________________
______________________________\\/\\\\\\_______________/\\\\\\\\\\\\\\\\\\\\\\\\\\______________________________
________________/\\\\\\\\\\_________\\/\\\\\\______________/\\\\\\/////////\\\\\\____/\\\\\\\\\\___________________
_______________/\\\\\\///\\\\\\__/\\\\\\_\\/\\\\\\_____________\\/\\\\\\_______\\/\\\\\\__/\\\\\\///\\\\\\__/\\\\\\___________
_______________\\///__\\///\\\\\\\\\\/__\\/\\\\\\_____________\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_\\///__\\///\\\\\\\\\\/____________
________________________\\/////____\\/\\\\\\_____________\\/\\\\\\/////////\\\\\\_________\\/////______________
___________________________________\\/\\\\\\_____________\\/\\\\\\_______\\/\\\\\\_____________________________
____________________________________\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_\\/\\\\\\_______\\/\\\\\\_____________________________
_____________________________________\\///////////////__\\///________\\///______________________________
____________/\\\\\\________/\\\\\\__/\\\\\\\\\\\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\\\\\\\\____/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\\\\________
____________\\/\\\\\\_______\\/\\\\\\_\\/////\\\\\\///____/\\\\\\/////////\\\\\\_\\///////\\\\\\/////____/\\\\\\\\\\\\\\\\\\\\\\\\\\______
_____________\\//\\\\\\______/\\\\\\______\\/\\\\\\______\\//\\\\\\______\\///________\\/\\\\\\________/\\\\\\/////////\\\\\\_____
_______________\\//\\\\\\____/\\\\\\_______\\/\\\\\\_______\\////\\\\\\_______________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_____
_________________\\//\\\\\\__/\\\\\\________\\/\\\\\\__________\\////\\\\\\____________\\/\\\\\\_______\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_____
___________________\\//\\\\\\/\\\\\\_________\\/\\\\\\_____________\\////\\\\\\_________\\/\\\\\\_______\\/\\\\\\/////////\\\\\\_____
_____________________\\//\\\\\\\\\\__________\\/\\\\\\______/\\\\\\______\\//\\\\\\________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_____
_______________________\\//\\\\\\________/\\\\\\\\\\\\\\\\\\\\\\_\\///\\\\\\\\\\\\\\\\\\\\\\/_________\\/\\\\\\_______\\/\\\\\\_______\\/\\\\\\_____
_________________________\\///________\\///////////____\\///////////___________\\///________\\///________\\///______
______________________/\\\\\\________/\\\\\\__/\\\\\\________/\\\\\\_______/\\\\\\\\\\__________/\\\\\\\\\\\\\\\\\\\\\\____________________
______________________\\/\\\\\\_____/\\\\\\//__\\/\\\\\\_______\\/\\\\\\_____/\\\\\\///\\\\\\______/\\\\\\/////////\\\\\\__________________
_______________________\\/\\\\\\__/\\\\\\//_____\\//\\\\\\______/\\\\\\____/\\\\\\/__\\///\\\\\\___\\//\\\\\\______\\///___________________
________________________\\/\\\\\\\\\\\\//\\\\\\______\\//\\\\\\____/\\\\\\____/\\\\\\______\\//\\\\\\___\\////\\\\\\__________________________
_________________________\\/\\\\\\//_\\//\\\\\\______\\//\\\\\\__/\\\\\\____\\/\\\\\\_______\\/\\\\\\______\\////\\\\\\_______________________
__________________________\\/\\\\\\____\\//\\\\\\______\\//\\\\\\/\\\\\\_____\\//\\\\\\______/\\\\\\__________\\////\\\\\\____________________
___________________________\\/\\\\\\_____\\//\\\\\\______\\//\\\\\\\\\\_______\\///\\\\\\__/\\\\\\_____/\\\\\\______\\//\\\\\\___________________
____________________________\\/\\\\\\______\\//\\\\\\______\\//\\\\\\__________\\///\\\\\\\\\\/_____\\///\\\\\\\\\\\\\\\\\\\\\\/____________________
_____________________________\\///________\\///________\\///_____________\\/////_________\\///////////______________________"
exit
