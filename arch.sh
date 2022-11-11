#!/usr/bin/env bash
# == arch linux installer == #

#part1
echo -e "\n\t\t---------- let shell do their job ----------\n\n"
echo -e "\n( make sure the internet is connected or press ctrl+c )\n"
sleep 4

## console keyboard layout
loadkeys us

## system clock
timedatectl set-ntp true

## partition the disks
lsblk
echo -e "\n\tenter the drive name with prefix /dev/ : "
read DRIVE
fdisk ${DRIVE}

## format the partitions
echo -e "\nenter the efi partition with prefix /dev/ : "
read EFIPARTITION
mkfs.vfat -F 32 ${EFIPARTITION}
echo -e "\nenter the linux partition with prefix /dev/ : "
read PARTITION
mkfs.ext4 ${PARTITION}

## mount the file systems
mount ${PARTITION} /mnt 
mkdir -p /mnt/boot/efi
mount ${EFIPARTITION} /mnt/boot/efi

## install the base system
printf '\033c'
echo -e "\n\tpartitions are mounted & installing the base system."
pacstrap /mnt base linux linux-firmware

## dwm install script
mv dwm.sh /mnt/dwm.sh

## generate an fstab file with UUID
genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#part2$/d' arch.sh > /mnt/temp.sh
chmod +x /mnt/temp.sh

## change root into the new system
arch-chroot /mnt ./temp.sh
exit 

#part2
printf '\033c'

## timezone
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

## hardware clock
hwclock --systohc

## localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
locale-gen

## hostname configuration
echo "hostname: "
read HOSTNAME
echo ${HOSTNAME} > /etc/hostname

## network configuration
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

## initramfs
mkinitcpio -P

## root password
echo -e "\n\n\t----- set root password -----\n"
passwd

## pkg installation
pacman -S --noconfirm bash-completion dosfstools efibootmgr \
	gcc git grub make man-db neovim networkmanager sudo

## boot loader configuration
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=-1/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

## enable NetworkManager
systemctl enable NetworkManager.service

## new regular user
echo -e "\n\n\t----- add new regular user -----\n\n"
echo "enter new username: "
read USERNAME
useradd -m -G wheel ${USERNAME}
passwd ${USERNAME}
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

## DWM auto-install script
chown ${USERNAME}:${USERNAME} /dwm.sh
chmod +x /dwm.sh
mv /dwm.sh /home/${USERNAME}/dwm.sh

## stop annoying beep sound
cat > /etc/modprobe.d/nobeep.conf << EOF
blacklist pcspkr
EOF

echo -e "\n\t\t---------- installation finished -- reboot now ----------\n\n"
rm /temp.sh
exit
