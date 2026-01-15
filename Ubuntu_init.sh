#!/bin/bash

# Function to ask for confirmation
confirm() {
    while true; do
        read -p "$1 [Y/n] " response
        response=${response,,} # Convert to lowercase
        if [[ -z "$response" ]] || [[ $response =~ ^(yes|y)$ ]]; then
            return 0
        elif [[ $response =~ ^(no|n)$ ]]; then
            return 1
        else
            echo "Invalid response. Please answer 'y' or 'n'"
        fi
    done
}

# Update package lists (Mandatory)
sudo apt update

# Update system packages (Mandatory)
sudo apt full-upgrade -y

# Install/configure utilities and extensions (Mandatory)
sudo apt install curl wget gparted exfat-fuse exfatprogs showtime rhythmbox gnome-extensions gnome-shell-extension-gpaste gnome-shell-extension-ubuntu-tiling-assistant gnome-tweaks gnome-shell-extension-gsconnect bleachbit -y

# Install themes and cursors
if confirm "Do you want to install papirus icon theme?"; then
    sudo apt install papirus-icon-theme papirus-colors -y
fi

if confirm "Do you want to install bibata cursor theme?"; then
    sudo apt install  bibata-cursor-theme -y
fi

# Configure starship prompt
if confirm "Do you want to configure starship prompt for bash?"; then
    sudo apt install starship -y
    echo eval "$(starship init bash)" >> ~/.bashrc
fi

# Download & Install necessary programs
if confirm "Do you want to download and install Google Chrome?"; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
fi

if confirm "Do you want to download and install Brave Browser?"; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

    sudo apt update
    sudo apt install brave-browser -y
fi

if confirm "Do you want to download and install ONLYOFFICE (MS Office Alternative)?"; then
    wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb

    sudo apt install ./onlyoffice-desktopeditors_amd64.deb -y
    rm onlyoffice-desktopeditors_amd64.deb
    sudo apt purge libreoffice libreoffice-* -y
fi

if confirm "Do you want to download and install Visual Studio Code?"; then
    sudo apt install build-essential make cmake gcc g++ -y
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode-stable_current_amd64.deb

    sudo apt install ./vscode-stable_current_amd64.deb -y
    rm vscode-stable_current_amd64.deb
fi

if confirm "Do you want to install Inkscape?"; then
    sudo apt install inkscape -y
fi

if confirm "Do you want to install Flameshot (screenshot tool)?"; then
    sudo apt install flameshot -y
fi

# Install Espanso (text expander)
if confirm "Do you want to install Espanso (text expander)?"; then
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        # Install Espanso for Wayland
        wget https://github.com/espanso/espanso/releases/latest/download/espanso-debian-wayland-amd64.deb
        sudo apt install ./espanso-debian-wayland-amd64.deb -y
        rm espanso-debian-wayland-amd64.deb
    else
        # Install Espanso for X11
        wget https://github.com/espanso/espanso/releases/latest/download/espanso-debian-x11-amd64.deb
        sudo apt install ./espanso-debian-x11-amd64.deb -y
        rm espanso-debian-x11-amd64.deb
    fi
    espanso service register
    espanso start
fi

# Install Espanso Shortcode Manager (TUI for Espanso)
if confirm "Do you want to install Espanso Shortcode Manager/ESC (TUI for Espanso)?"; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/pptoolbox/esc/main/install.sh)"
fi

# Add wallpapers
if confirm "Do you want to install wallpapers?"; then
    if [[ -d wallpapers ]]; then
        sudo mv wallpapers /usr/local/share/
    else
        echo "Wallpaper directory not found, skipping."
    fi
fi

# Mandetory cleanup
sudo apt purge snap snapd htop -y
sudo apt autopurge -y
sudo apt clean
sudo apt autoclean

echo "Ubuntu initialization completed. Enjoy!"