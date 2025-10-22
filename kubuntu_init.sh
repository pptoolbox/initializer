#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install/configure utilities
sudo apt install wget gparted copyq exfat-fuse exfatprogs vlc inkscape kdeconnect preload starship bibata-cursor-theme -y

sudo systemctl enable preload.service

echo eval "$(starship init bash)" >> ~/.bashrc

# Download & Install necessary programs
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode-stable_current_amd64.deb
wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb

sudo apt install ./*.deb -y

# Remove unnecessary files/packages
rm -r ./*.deb
sudo apt autoremove -y
sudo apt clean
sudo apt autoclean
