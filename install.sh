#!/bin/bash

echo -ne    

"
-----------------------------------
      _                      _     
     (_)      /\            | |    
  ___ _ _ __ /  \   _ __ ___| |__  
 / __| | '__/ /\ \ | '__/ __| '_ \ 
 \__ \ | | / ____ \| | | (__| | | |
 |___/_|_|/_/    \_\_|  \___|_| |_|
-----------------------------------"

readarray -t APPS < packages.txt
file="/etc/fstab"
entry="//10.10.10.200/media /home/sirdicholas/media cifs _netdev,nofail,username=sirdicholas,password=g8e3r7a3 0 0"
PACMAN="/etc/pacman.conf"
MULT="[multilib]"
CHAOTIC="[chaotic-aur]"


installYay(){

    sudo pacman -S git base-devel --noconfirm
    # Clone yay repository from GitHub
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
    # Change directory to the cloned repository
    cd /tmp/yay
    # Build and install yay
    makepkg -si --noconfirm
    # Remove the cloned repository
    rm -rf /tmp/yay

}

################################################################

editPacman(){

    # Backup the original pacman.conf
    sudo cp $PACMAN /etc/pacman.conf.bak
    echo "Backed up original /etc/pacman.conf to /etc/pacman.conf.bak"
    
    # Edit the pacman.conf file to enable multilib
    sudo sed -i '/\[multilib\]/,/^#/ s/^#//' $PACMAN
    echo "Enabled multilib in /etc/pacman.conf"
    
    sudo sed -i '/#Color/{s/^#//}' $PACMAN
    
    yay --noconfirm
    
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB 
    
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    
    echo "[chaotic-aur]" | sudo tee -a $PACMAN > /dev/null
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a $PACMAN > /dev/null
    
    yay --noconfirm

}

################################################################

installApps(){

    yay -S ${APPS[@]} --noconfirm
    sudo systemctl enable sddm
    sudo systemctl enable lactd
    sudo systemctl enable bluetooth

}

################################################################

copyFiles(){

    sudo cp -Rf configs/system/* / && sudo cp -Rf configs/home/* ~/

}

################################################################

editETC(){

    echo $entry | sudo tee -a $file > /dev/null
    sudo sed -i 's|sirdicholas:/usr/bin/bash|sirdicholas:/usr/bin/fish|g' /etc/passwd

}

installYay
editPacman
installApps
copyFiles
editETC