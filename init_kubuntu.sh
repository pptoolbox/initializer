#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install wget gparted copyq exfat-fuse exfatprogs vlc inkscape kdeconnect preload starship -y

echo eval "$(starship init bash)" >> ~/.bashrc

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode-stable_current_amd64.deb
wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb

sudo apt install ./*.deb

rm -r ./*.deb
