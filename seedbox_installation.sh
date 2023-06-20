#!/bin/bash

## Update Installed Packages & Installing Essential Packages
function Update {
    normal_1; echo "Updating installed packages and install prerequisite"
    normal_2
    apt-get -qqy update && apt-get -qqy upgrade
    apt-get -qqy install sudo sysstat htop curl psmisc
    cd $HOME
    tput sgr0; clear
}

## qBittorrent
function qBittorrent {
    warn_2
    source <(wget -qO- https://raw.githubusercontent.com/eros520/Seedbox-Components-Arm/main/Torrent%20Clients/qBittorrent/qBittorrent_install.sh)
    qBittorrent_download
    qBittorrent_install
    qBittorrent_config
    qbport=$(grep -F 'WebUI\Port'  /home/$username/.config/qBittorrent/qBittorrent.conf | grep -Eo '[0-9]{1,5}')
    tput sgr0; clear
}
