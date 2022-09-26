#!/bin/bash
clear
echo "#############################
This is KV's arch installation script
#############################"

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf

loadkeys us
timedatectl set-ntp true
pkgs="base linux linux-firmware linux-headers opendoas neovim networkmanager zsh git sed rsync"

clear
echo "Do you want to install grub bootloader?"
select yn in "Yes, install grub" "No, don't install grub"
do
    case $yn in
        "Yes, install grub" )
            grubanswer="y"
            pkgs+=" grub os-prober"
            if [ -d /sys/firmware/efi ]
            then
                pkgs+=" efibootmgr"
                bios="UEFI"
                echo "You have an $bios system"
                echo "You have to create an EFI system partition"
                read -p "press enter to continue "
            else
                bios="BIOS"
                echo "You have a $bios system."
                echo "Create a bios boot partition for GPT. No need for separate boot partition for MBR"
                read -p "press enter to continue "
            fi
            break
            ;;
        "No, don't install grub" )
            grubanswer="n"
            break
            ;;
        * ) echo "Please enter either 1 or 2" ;;
    esac
done

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
if [[ $grubanswer == "y" ]]
then
    if [[ $bios == "UEFI" ]]
    then
        lsblk
        echo -e "\n"
        read -p "Enter EFI partition (e.g. /dev/sda1 or /dev/nvme0n1p1): " efipartition
        mkfs.fat -F 32 $efipartition
        mount --mkdir $efipartition /mnt/boot
    fi
    sed --expression "2s|^|grubanswer=$grubanswer\nbios=$bios\ndrive=$drive\n|" configuration-script.sh > /mnt/configuration-script.sh
else
    sed --expression "2s|^|grubanswer=$grubanswer\nbios=\"not installing\"\ndrive=$drive\n|" configuration-script.sh > /mnt/configuration-script.sh
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
    pacstrap /mnt $(echo $pkgs)
    read -p "Installation ended successfully? (y/n): " noerror
done

clear ; echo -e "\n Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "copying configuration script..."
cp packages.md dotfile-setup.sh /mnt/

chmod +x /mnt/configuration-script.sh

arch-chroot /mnt ./configuration-script.sh

[[ $bios == "UEFI" ]] && umount /mnt/boot
umount /mnt
