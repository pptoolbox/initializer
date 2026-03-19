#!/bin/bash

# Enable Btrfs quotas and configure Snapper for system snapshots
sudo pacman -Sy snap-pac grub-btrfs
sudo btrfs quota enable /
sudo sed -i 's/QGROUP=""/QGROUP="1\/0"/g' /etc/snapper/configs/root
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Update system and install essential packages
sudo pacman -Syu firefox gwenview okular kdeconnect inkscape vlc papirus-icon-theme filelight yakuake partitionmanager exfatprogs dosfstools ntfs-3g e2fsprogs btrfs-progs xfsprogs kio-admin git curl wget base-devel sshfs tesseract-data-eng starship bash-completion

# Configure Starship prompt and bash completion
echo "eval "$(starship init bash)"" >> ~/.bashrc 
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc

# Install yay AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install AUR packages
yay -Sy brave-bin bibata-cursor-theme-bin ttf-dm-mono-git papirus-colors-git

# Cleanup unnecessary packages
sudo pacman -Rns htop