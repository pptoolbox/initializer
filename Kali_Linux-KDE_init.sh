#!/bin/bash

echo "Updating the system and installing useful utilities..."

# Upgrade System (Mandatory)
sudo apt update

# Update system packages (Mandatory)
sudo apt full-upgrade -y

# Install/configure utilities (Mandatory)
sudo apt install curl wget partitionmanager filelight exfatprogs vlc kdeconnect okular okular-extra-backends bleachbit -y

# Enable required services (Mandatory)
sudo systemctl enable --now bluetooth.service

mkdir -p ~/.config/systemd/user
echo "[Unit]
Description=KDE Connect Daemon
After=graphical-session.target

[Service]
ExecStart=/usr/bin/kdeconnectd
Restart=on-failure

[Install]
WantedBy=default.target" >> ~/.config/systemd/user/kdeconnectd.service
systemctl --user daemon-reexec
systemctl --user enable kdeconnectd.service
systemctl --user start kdeconnectd.service

# Prompt user for automated or manual setup
echo "Do you want to do automated setup? (Type 'Yup' to proceed or [ENTER] to skip and continue manually)"
read ans

ans=$(echo "$ans" | tr '[:upper:]' '[:lower:]')

if [[ "$ans" == "yup" ]]; then
    sudo apt install papirus-icon-theme -y
    sudo apt install bibata-cursor-theme -y

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update
    sudo apt install brave-browser -y

    wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb
    sudo apt install ./onlyoffice-desktopeditors_amd64.deb -y
    rm onlyoffice-desktopeditors_amd64.deb
    sudo apt purge libreoffice libreoffice-* -y

    sudo apt install build-essential make cmake gcc g++ -y
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode-stable_current_amd64.deb
    sudo apt install ./vscode-stable_current_amd64.deb -y
    rm vscode-stable_current_amd64.deb

    sudo apt install inkscape -y

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

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/pptoolbox/esc/main/install.sh)"

    sudo mv wallpapers /usr/local/share/

    # Mandatory cleanup
    sudo apt autopurge -y
    sudo apt clean
    sudo apt autoclean

    echo "Kubuntu initialization completed. Enjoy!"
elif [[ -z "$ans" ]]; then
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

    # Install themes and cursors
    if confirm "Do you want to install papirus icon theme?"; then
        sudo apt install papirus-icon-theme papirus-colors -y
    fi

    if confirm "Do you want to install bibata cursor theme?"; then
        sudo apt install  bibata-cursor-theme -y
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

    # Install Yakuake (Dropdown terminal emulator)
    if confirm "Do you want to install Yakuake (dropdown terminal emulator)?"; then
        sudo apt install yakuake -y
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


    # Mandatory cleanup
    sudo apt autopurge -y
    sudo apt clean
    sudo apt autoclean

    echo "Kubuntu initialization completed. Enjoy!"
else
    echo "Invalid input. Please run the script again and provide a valid response."
fi
