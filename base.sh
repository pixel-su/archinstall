#!/bin/bash

nano /etc/pacman.conf
nano /etc/pacman.d/mirrorlist

pacman -Syy

echo -e "\033[1;34mNTP : True >>\033[0m"

timedatectl set-ntp true
timedatectl

echo -e "\033[1;34mWiping partitions >>\033[0m"

sgdisk --zap-all /dev/nvme0n1
sgdisk --zap-all /dev/sda

echo -e "\033[1;34mSetting up system partitions - /dev/nvme0n1 >>\033[0m"

sgdisk -o /dev/nvme0n1 \
  -n 1:0:+1G -t 1:EF00 \
  -n 2:0:0 -t 2:8300 \
  -p

echo -e "\033[1;34mSetting up swap partitions - /dev/sda >>\033[0m"

sgdisk -o /dev/sda \
  -n 1:0:+4G -t 1:8200 \
  -p

partprobe /dev/nvme0n1
partprobe /dev/sda

lsblk

sleep 1

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi

mkswap /dev/sda1
swapon /dev/sda1

pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers nano wget amd-ucode reflector wpa_supplicant networkmanager iwd iw
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
sleep 1
echo -e "\033[1;34mNext >>\033[0m"