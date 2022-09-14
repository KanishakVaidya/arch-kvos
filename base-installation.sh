#!/bin/bash
echo "This is KV's arch installation script
Root filesystem: ext4"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

lsblk

read -p "Enter the drive (e.g. /dev/sda or /dev/nvme0n1): " drive
cfdisk $drive

lsblk
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

pacstrap /mnt base base-devel linux linux-firmware linux-headers opendoas neovim networkmanager git

genfstab -U /mnt >> /mnt/etc/fstab

cp dotfile-setup.sh configuration-script.sh /mnt/

echo "Now mount arch-chroot $partition and run configuration script"
