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

# Update package lists(Mandatory)
sudo apt update

# Update system
if confirm "Do you want to update the system?"; then
    sudo apt full-upgrade -y
fi

# Install/configure utilities
if confirm "Do you want to install utilities?"; then
    sudo apt install curl wget exfat-fuse exfatprogs -y
fi

# Enable preload service
if confirm "Do you want to enable preload service?"; then
    sudo apt install preload -y
    sudo systemctl enable preload.service
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

if confirm "Do you want to download and install ONLYOFFICE?"; then
    wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb

    sudo apt install ./onlyoffice-desktopeditors_amd64.deb -y
    rm onlyoffice-desktopeditors_amd64.deb
fi

if confirm "Do you want to download and install Visual Studio Code?"; then
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode-stable_current_amd64.deb

    sudo apt install ./vscode-stable_current_amd64.deb -y
    rm vscode-stable_current_amd64.deb
fi

if confirm "Do you want to install Inkscape?"; then
    sudo apt install inkscape -y
fi

if confirm "Do you want to change screenshot/screencast utility to flameshot/kazam?"; then
    sudo apt install flameshot kazam -y
    # Disable default screenshot shortcuts
    gsettings set org.cinnamon.desktop.keybindings.media-keys screenshot "[]"
    gsettings set org.cinnamon.desktop.keybindings.media-keys window-screenshot "[]"
    gsettings set org.cinnamon.desktop.keybindings.media-keys area-screenshot "[]"

    # Prepare the custom list
    CUSTOM_LIST=$(gsettings get org.cinnamon.desktop.keybindings.custom-list | tr -d "[]'")
    NEW_ENTRIES=()

    # Function to add a new custom binding
    add_binding() {
        ID=$1
        NAME=$2
        CMD=$3
        KEY=$4

        gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$ID/ name "$NAME"
        gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$ID/ command "$CMD"
        gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$ID/ binding "['$KEY']"

        NEW_ENTRIES+=("'$ID'")
    }

    # Add Flameshot (Print)
    add_binding "custom_flameshot" "Flameshot GUI" "flameshot gui" "Print"

    # Add Kazam (Shift+Print)
    add_binding "custom_kazam" "Kazam Recorder" "kazam" "<Shift>Print"

    # Merge with existing custom list
    ALL=$(echo $CUSTOM_LIST ${NEW_ENTRIES[@]} | tr ' ' ',')
    gsettings set org.cinnamon.desktop.keybindings.custom-list "[$ALL]"

    # Remove gnome-screenshot
    sudo apt purge gnome-screenshot -y
fi

# Add wallpapers
if confirm "Do you want to install wallpapers?"; then
    sudo mv wallpapers /usr/local/share/
fi

# Cleanup
if confirm "Do you want to remove firefox?"; then
    sudo apt purge firefox -y
fi

if confirm "Do you want to remove libreoffice?"; then
    sudo apt purge libreoffice -y
fi

if confirm "Do you want to cleanup?"; then
    sudo apt purge thunderbird transmission hexchat remmina warpinator -y
    sudo apt autopurge -y
    sudo apt clean
    sudo apt autoclean
fi

echo "Linux Mint Cinnamon initialization completed. Enjoy!"