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

passwd

read -p "Enter a username: " username
useradd -m -G audio,video,storage,optical,wheel -s /usr/bin/zsh $username
passwd $username
echo "permit persist :wheel as root" >> /etc/doas.conf

pacman --noconfirm -S sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

pacman --noconfirm -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=myArch
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager.service

mv dotfile-setup.sh /home/$username

echo "Now you can exit out of the chrooted environment. Unmount the drives mounted in /mnt and reboot."
