#!/bin/bash
echo -ne"
-----------------------------------
      _                      _     
     (_)      /\            | |    
  ___ _ _ __ /  \   _ __ ___| |__  
 / __| | '__/ /\ \ | '__/ __| '_ \ 
 \__ \ | | / ____ \| | | (__| | | |
 |___/_|_|/_/    \_\_|  \___|_| |_|
-----------------------------------
"
# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null ;
}

package_exists() {
    pacman -Q "$1" &> /dev/null ;
}



#installYay() {
    if package_exists yay; then
        echo "yay is already installed"
        #return
    else
        if ! command_exists git; then
            sudo pacman -S git --noconfirm
        fi

        if ! command_exists base-devel; then
        sudo pacman -S base-devel --noconfirm
        fi
        # Clone yay repository from GitHub
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
        # Change directory to the cloned repository
        cd /tmp/yay
        # Build and install yay
        makepkg -si --noconfirm
        # Remove the cloned repository
        rm -rf /tmp/yay
    fi
#}
#installYay

#add Chaotic AUR and enable multilib

# Check if /etc/pacman.conf exists

    PACMAN="/etc/pacman.conf"
    MULT="[multilib]"
    CHAOTIC="[chaotic-aur]\n
Include = /etc/pacman.d/chaotic-mirrorlist"

    if [ ! -f $PACMAN ]; then
        echo "Error: $PACMAN not found." >&2
        exit 1
    fi

    if grep -q $CHAOTIC $PACMAN && grep -q $MULT $PACMAN; then
        exit 1
    fi

    # Backup the original pacman.conf
    sudo cp $PACMAN /etc/pacman.conf.bak
    echo "Backed up original /etc/pacman.conf to /etc/pacman.conf.bak"

    # Edit the pacman.conf file to enable multilib
    sudo sed -i '/\[multilib\]/,/^#/ s/^#//' $PACMAN
    echo "Enabled multilib in /etc/pacman.conf"

    sudo sed -1 '/#Color/{s/^#//}' $PACMAN

    yay --noconfirm

    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com --noconfirm
    sudo pacman-key --lsign-key 3056513887B78AEB --noconfirm

    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

    sudo echo "[chaotic-aur]">> $PACMAN
    sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> $PACMAN

#install apps

#yay -S neovim --noconfirm

