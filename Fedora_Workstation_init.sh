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

# Update system packages (Mandatory)
sudo dnf upgrade -y

# Install/configure utilities and extensions (Mandatory)
sudo dnf install curl wget dnf-plugins-core gparted gnome-tweaks gnome-extensions-app gnome-shell-extension-gsconnect gnome-shell-extension-gpaste bleachbit -y

# Install themes and cursors
if confirm "Do you want to install papirus icon theme?"; then
    sudo dnf install papirus-icon-theme -y
fi

# Configure starship prompt
if confirm "Do you want to configure starship prompt for bash?"; then
    sudo dnf copr enable atim/starship -y
    sudo dnf install starship -y
    grep -qxF 'eval "$(starship init bash)"' ~/.bashrc || \
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# Download & Install necessary programs
if confirm "Do you want to download and install Google Chrome?"; then
    sudo dnf install google-chrome-stable -y
fi

if confirm "Do you want to download and install Brave Browser?"; then
    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
    sudo dnf install brave-browser -y
fi

if confirm "Do you want to download and install Libreoffice (MS Office Alternative)?"; then
    sudo dnf install libreoffice libreoffice-gnome -y
fi

if confirm "Do you want to download and install Visual Studio Code?"; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    sudo dnf install code -y
fi

if confirm "Do you want to install Inkscape?"; then
    sudo dnf install inkscape -y
fi

if confirm "Do you want to install Flameshot (screenshot tool)?"; then
    sudo dnf install flameshot -y
fi

# Add wallpapers
if confirm "Do you want to install wallpapers?"; then
    if [[ -d wallpapers ]]; then
        sudo mv wallpapers /usr/local/share/
    else
        echo "Wallpaper directory not found, skipping."
    fi
fi

# Mandatory cleanup
sudo dnf remove firefox gnome-boxes -y

echo "Fedora Workstation initialization completed. Enjoy!"