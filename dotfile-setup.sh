echo "
██╗░░██╗██╗░░░██╗░█████╗░░██████╗  ██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░███████╗██████╗░
██║░██╔╝██║░░░██║██╔══██╗██╔════╝  ██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░██╔════╝██╔══██╗
█████═╝░╚██╗░██╔╝██║░░██║╚█████╗░  ██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░█████╗░░██████╔╝
██╔═██╗░░╚████╔╝░██║░░██║░╚═══██╗  ██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░██╔══╝░░██╔══██╗
██║░╚██╗░░╚██╔╝░░╚█████╔╝██████╔╝  ██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗███████╗██║░░██║
╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═════╝░  ╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝╚═╝░░╚═╝
        "

echo "Please grant root priveliges to $USER"

curl -fLo /tmp/packages.md https://raw.githubusercontent.com/KanishakVaidya/arch-KVOS/main/packages.md
nvim /tmp/packages.md

noerror='n'
while [[ $noerror != 'y'  ]]
do
    doas pacman -S --needed --noconfirm $(awk '/\- \[X\]/ {getline ; print}' /tmp/packages.md | tr "\n" " " )
    read -p "Installation ended successfully? (y/n): " noerror
done
echo 'export ZDOTDIR="$HOME"/.config/zsh' | doas tee /etc/zsh/zshenv

#!/bin/bash
[[ -d $HOME/Desktop ]] && mv $HOME/Desktop $HOME/desktop || mkdir -p $HOME/desktop
[[ -d $HOME/Downloads ]] && mv $HOME/Downloads $HOME/dwn || mkdir -p $HOME/dwn
[[ -d $HOME/Templates ]] && mv $HOME/Templates $HOME/templates || mkdir -p $HOME/templates
[[ -d $HOME/Public ]] && mv $HOME/Public $HOME/shared || mkdir -p $HOME/shared
[[ -d $HOME/Documents ]] && mv $HOME/Documents $HOME/doc || mkdir -p $HOME/doc
[[ -d $HOME/Music ]] && mv $HOME/Music $HOME/music || mkdir -p $HOME/music
[[ -d $HOME/Pictures ]] && mv $HOME/Pictures $HOME/pic || mkdir -p $HOME/pic
[[ -d $HOME/Videos ]] && mv $HOME/Videos $HOME/vid || mkdir -p $HOME/vid
mkdir -p $HOME/pic/.wall $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config $HOME/.local/share/AppImages $HOME/.local/share/fonts

xdg-user-dirs-update
fc-cache -fv

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

git clone --depth=1 https://github.com/KanishakVaidya/wallpapers.git $HOME/pic/.wall

echo "setting a link to xresources"
ln -sf $HOME/.config/Xresources/codedark $HOME/.Xresources

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c PlugInstall -c qa
clear

echo "Now you can restart the system. Log into your account and start the session using startx command"
exit
