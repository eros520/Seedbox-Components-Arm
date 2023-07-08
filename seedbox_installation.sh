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
    # qBittorrent
    normal_2
    unset e
    if [ -z ${qbport+x} ]; then echo "Skipping qBittorrent since it is not installed"; else Decision2 qBittorrent; fi
    if [ "${e}" == "0" ]; then
        normal_1; echo "Configuring autoremove-torrents for qBittorrent"
        warn_2
        touch $HOME/.config.yml
        cat << EOF >>$HOME/.config.yml
General-qb:          
  client: qbittorrent
  host: http://127.0.0.1:$qbport
  username: $username
  password: $password
  strategies:
    Upload:
      status:
        - Uploading
      remove: upload_speed < 1024 and seeding_time > $seedtime
    Disk:
      free_space:
        min: $diskspace
        path: /home/$username/
        action: remove-old-seeds
  delete_data: true
EOF
    fi
    sed -i 's+127.0.0.1: +127.0.0.1:+g' $HOME/.config.yml
    mkdir $HOME/.autoremove-torrents && chmod 755 $HOME/.autoremove-torrents
    touch $HOME/.autoremove.sh
    cat << EOF >$HOME/.autoremove.sh
#!/bin/sh

while true; do
  /usr/local/bin/autoremove-torrents --conf=$HOME/.config.yml --log=$HOME/.autoremove-torrents
  sleep 5
done
EOF
    chmod +x $HOME/.autoremove.sh
    normal_2
    apt-get -qqy install screen
    screen -dmS autoremove-torrents $HOME/.autoremove.sh
}
