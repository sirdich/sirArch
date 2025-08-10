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

installYay() {
    if package_exists yay; then
        echo "yay is already installed"
        #return
    else
        sudo pacman -S git base-devel --noconfirm
        # Clone yay repository from GitHub
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
        # Change directory to the cloned repository
        cd /tmp/yay
        # Build and install yay
        makepkg -si --noconfirm
        # Remove the cloned repository
        rm -rf /tmp/yay
    fi
}
installYay

pacmanConfig(){

    PACMAN="/etc/pacman.conf"
    MULT="[multilib]"
    CHAOTIC="[chaotic-aur]"
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
pacmanConfig

yay
app_file="packages.txt"
readarray -t apps <"$app_file"
echo "Installing the following apps ${apps[@]}"
#this doesn't work for some reason
#yay -S ${apps[@]} --noconfirm
yay -S plasma-desktop plasma-disks plasma-firewall plasma-integration plasma-nm plasma-pa plasma-systemmonitor kscreen breeze bluedevil sddm sddm-kcm spectacle dolphin dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers xsettingsd plasma-workspace-wallpapers kde-wallpapers konsole mesa mesa-utils lib32-mesa vulkan-radeon lib32-vulkan-radeon nvtop neovim fish ttf-meslo-nerd ttf-nerd-fonts-symbols ttf-noto-nerd noto-fonts noto-fonts-emoji noto-fonts-extra lact btop btop-theme-catppuccin rocm-smi-lib steam winetricks protontricks gamemode gamescope zen-browser-bin protonup-qt-bin proton-ge-custom-bin reflector-simple vscodium-bin auto-cpufreq beeper-v4-bin mangohud goverlay heroic-games-launcher-bin kvantum mpv mission-center timeshift papirus-folders papirus-icon-theme fastfetch checkupdates-with-aur jq cifs-utils sddm-catppuccin-git hunspell-en_us --noconfirm
sudo systemctl enable sddm
sudo systemctl enable lactd
sudo systemctl enable bluetooth

sudo cp -Rf ./configs/system/. / && sudo cp -Rf ./configs/home/. ~/
file="/etc/fstab"
entry="//10.10.10.200/media /home/sirdicholas/media cifs _netdev,nofail,username=sirdicholas,password=g8e3r7a3 0 0"
echo $entry | sudo tee -a $file > /dev/null

sudo sed -i 's|sirdicholas:/usr/bin/bash|sirdicholas:/usr/bin/fish|g' /etc/passwd



