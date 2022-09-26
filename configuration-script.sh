#!/bin/bash
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

clear ; echo -e "Setting Root Password \n"
passwd

echo -e "\n Setting up a user...\n"
read -p "Enter a username: " username
useradd -m -G audio,video,storage,optical,wheel -s /usr/bin/zsh $username
passwd $username
echo "permit persist $username as root" > /etc/doas.conf
echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv
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
chown $username dotfile-setup.sh packages.md 
mv dotfile-setup.sh packages.md /home/$username

echo -e "A base arch system is installed \nDo you want to install custom i3wm desktop (KVOS)"
select yn in "Yes, install KVOS" "No, continue with vanilla arch"
do
    case $yn in
        "Yes, install KVOS" )
            su -s /bin/bash -c /home/$username/dotfile-setup.sh $username
            break
            ;;
        "No, continue with vanilla arch")
            echo "Hasta la Vista, $username"
            break
            ;;
        * ) echo "Please enter 1 or 2" ;;
    esac
done

echo "Now you can exit out of the chrooted environment. Unmount the drives mounted in /mnt and reboot."
