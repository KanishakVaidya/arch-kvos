#!/bin/bash
config_text='
  /$$$$$$                        /$$                                    /$$$$$$                       /$$$$$$  /$$          
 /$$__  $$                      | $$                                   /$$__  $$                     /$$__  $$|__/          
| $$  \__/ /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$  /$$$$$$/$$$$       | $$  \__/  /$$$$$$  /$$$$$$$ | $$  \__/ /$$  /$$$$$$ 
|  $$$$$$ | $$  | $$ /$$_____/|_  $$_/   /$$__  $$| $$_  $$_  $$      | $$       /$$__  $$| $$__  $$| $$$$    | $$ /$$__  $$
 \____  $$| $$  | $$|  $$$$$$   | $$    | $$$$$$$$| $$ \ $$ \ $$      | $$      | $$  \ $$| $$  \ $$| $$_/    | $$| $$  \ $$
 /$$  \ $$| $$  | $$ \____  $$  | $$ /$$| $$_____/| $$ | $$ | $$      | $$    $$| $$  | $$| $$  | $$| $$      | $$| $$  | $$
|  $$$$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$ | $$ | $$      |  $$$$$$/|  $$$$$$/| $$  | $$| $$      | $$|  $$$$$$$
 \______/  \____  $$|_______/    \___/   \_______/|__/ |__/ |__/       \______/  \______/ |__/  |__/|__/      |__/ \____  $$
           /$$  | $$                                                                                               /$$  \ $$
          |  $$$$$$/                                                                                              |  $$$$$$/
           \______/                                                                                                \______/
                                                                                                                   '
echo "$config_text"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
read -p "Hostname: " hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts

mkdir -p /etc/X11/xorg.conf.d/
echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/30-touchpad.conf
echo '    Identifier "touchpad"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo '    Driver "libinput"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo '    MatchIsTouchpad "on"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo '    	Option "Tapping" "on"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo '	Option "ScrollMethod" "twofinger"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo '	Option "NaturalScrolling" "true"' >> /etc/X11/xorg.conf.d/30-touchpad.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/30-touchpad.conf

clear
echo "$config_text"
echo -e "Setting Root Password \n"
passwd

echo -e "\n Setting up a user...\n"
read -p "Enter a username: " username
useradd -m -G audio,video,storage,optical,wheel $username
passwd $username
echo "permit persist $username as root" > /etc/doas.conf
echo "setting a link to doas"
ln -sf /bin/doas /bin/sudo

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

if [[ $grubanswer == "y" ]] ; then
    echo "Setting up GRUB"
    case $bios in
        UEFI ) grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=myArch ;;
        BIOS ) grub-install --target=i386-pc $drive ;;
    esac
    grub-mkconfig -o /boot/grub/grub.cfg
fi


systemctl enable NetworkManager.service
exit
