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
echo -e "\n\n\n"
read -p "Enter the drive (e.g. /dev/sda or /dev/nvme0n1): " drive
cfdisk $drive

clear
lsblk
echo -e "\n\n\n"
read -p "Enter the root partition (e.g. /dev/sda3 or /dev/nvme0n1p3): " partition
mkfs.ext4 $partition
mount $partition /mnt

read -p "Create efi partition? [y/n]" efianswer
if [[ $efianswer = y ]] ; then
  lsblk
  read -p "Enter EFI partition (e.g. /dev/sda1 or /dev/nvme0n1p1): " efipartition
  mkfs.fat -F 32 $efipartition
  mount --mkdir $efipartition /mnt/boot
fi

read -p "Create swap partition? [y/n]" swpanswer
if [[ $swpanswer = y ]] ; then
  lsblk
  read -p "Enter EFI partition (e.g. /dev/sda2 or /dev/nvme0n1p2): " swap_partition
  mkswap $swap_partition
  swapon $swap_partition
fi

clear
pacstrap /mnt base linux linux-firmware linux-headers opendoas neovim networkmanager git

clear ; echo -e "\n\n\n Generating fstab \n\n\n"
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "\n\n\n copying configuration script \n\n\n"
cp dotfile-setup.sh configuration-script.sh /mnt/

echo "Now mount arch-chroot $partition and run configuration script"
