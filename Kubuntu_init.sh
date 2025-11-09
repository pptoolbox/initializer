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

# Upgrade System (Mandatory)
sudo apt update

# Update system packages (Mandatory)
sudo apt full-upgrade -y

# Install/configure utilities (Mandatory)
sudo apt install curl wget partitionmanager filelight exfat-fuse exfatprogs vlc kdeconnect -y

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

# Add wallpapers
if confirm "Do you want to install wallpapers?"; then
    sudo mv wallpapers /usr/local/share/
fi


# Create SCleaner script and desktop entry
if confirm "Do you want to install SCleaner?"; then
    mkdir -p ~/.local/bin
echo "#!/bin/bash
sudo apt update
sudo apt autopurge -y
sudo apt autoclean -y
sudo apt clean -y
echo "System cleanup completed."" >> ~/.local/bin/scleaner.sh

chmod +x ~/.local/bin/scleaner.sh

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=SCleaner
Comment=Clean up system cache and unnecessary files
Exec=/home/$USER/.local/bin/scleaner.sh
Icon=sweeper
Terminal=true
Categories=Utility;" >> ~/.local/share/applications/scleaner.desktop
fi

# Mandatory cleanup
sudo apt purge snap snapd plasma-discover-backend-snap htop -y
sudo apt autopurge -y
sudo apt clean
sudo apt autoclean

echo "Kubuntu initialization completed. Enjoy!"