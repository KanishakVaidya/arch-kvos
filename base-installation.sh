#!/bin/bash
clear
echo "#############################
This is KV's arch installation script
#############################"

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

clear
lsblk
echo -e "\n"
read -p "Enter the drive (e.g. /dev/sda or /dev/nvme0n1): " drive
cfdisk $drive

clear
lsblk
echo -e "\n"
read -p "Enter the root partition (e.g. /dev/sda2 or /dev/nvme0n1p2): " partition
mkfs.ext4 $partition
mount $partition /mnt

clear
read -p "Create efi partition? [y/n]: " efianswer
if [[ $efianswer = y ]] ; then
  lsblk
  echo -e "\n"
  read -p "Enter EFI partition (e.g. /dev/sda1 or /dev/nvme0n1p1): " efipartition
  mkfs.fat -F 32 $efipartition
  mount --mkdir $efipartition /mnt/boot
fi

clear
read -p "Create swap partition? [y/n]: " swpanswer
if [[ $swpanswer = y ]] ; then
  lsblk
  echo -e "\n"
  read -p "Enter swap partition (e.g. /dev/sda3 or /dev/nvme0n1p3): " swap_partition
  mkswap $swap_partition
  swapon $swap_partition
fi

clear
noerror='n'
while [[ $noerror != 'y'  ]]
do
    pacstrap /mnt base linux linux-firmware linux-headers opendoas neovim networkmanager zsh git rsync
    read -p "Installation ended successfully? (y/n): " noerror
done

clear ; echo -e "\n Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "copying configuration script..."
cp packages.md dotfile-setup.sh configuration-script.sh /mnt/

chmod +x /mnt/configuration-script.sh

arch-chroot /mnt ./configuration-script.sh
