# nixos server configuration

*embrace declarative.*

![nixos](https://img.shields.io/badge/nixos-26.05-5277c3?style=for-the-badge&logo=nixos) ![linux](https://img.shields.io/badge/linux-fcc624?style=for-the-badge&logo=linux) ![openssh](https://img.shields.io/badge/openssh-enabled-000000?style=for-the-badge&logo=openssh)

custom nixos server running on a hp laptop 15s-fq2xxx - just a minecraft and media server.

### overview

```
.
├── .gitignore
├── alias.nix
├── configuration.nix
├── media.nix
├── minecraft-backup.nix
├── minecraft.nix
├── networking.nix.template
└── vpn-torrent.nix.template
```

### the files and what they configure

- `configuration.nix`: main entry point, imports every file below plus `hardware-configuration.nix` and `networking.nix`
- `alias.nix`: shell aliases for rebuilding, editing configs and managing the minecraft server
- `minecraft.nix`: a paper minecraft server in a podman container, 6gb of memory, ports 25565/tcp and 24454/udp
- `minecraft-backup.nix`: nightly timer that stops the server, syncs `/var/lib/minecraft` to google drive with rclone, then starts it back up
- `media.nix`: jellyfin and qbittorrent, plus the shared `media` group and storage folders under `/mnt/storage`
- `networking.nix.template`: copy this to `networking.nix` and fill in your own wifi details
- `vpn-torrent.nix.template`: copy this to `vpn-torrent.nix` and fill in your own vpn details - same as the wifi

### pre-install

go to `nmtui` and setup wifi

run `sudo nano /etc/nixos/configuration.nix` and add both git and enable openssh

then `sudo nixos-rebuild switch`

### install

clone this repository  

```
cd ~
```

```
git clone https://github.com/hcg-leo/nixos-server
```

go to `nixos-server/networking.nix` and setup wifi (in the cloned repository)  
copy networking.nix.template to networking.nix

```
cp nixos-server/networking.nix.template nixos-server/networking.nix
```

```
nano nixos-server/networking.nix
```
copy vpn-torrent.nix.template to vpn-torrent.nix
```
cp ~/nixos-server/vpn-torrent.nix.template ~/nixos-server/vpn-torrent.nix
```
```
nano ~/nixos-server/vpn-torrent.nix
```

copy `/etc/nixos/hardware-configuration.nix` into the cloned repo

```
cp /etc/nixos/hardware-configuration.nix ~/nixos-server
```

`configuration.nix` also expects `vpn-torrent.nix` and `btop.nix` to exist in this folder - `vpn-torrent.nix` gets created in the vpn section further down, `btop.nix` needs adding by hand or removing from the imports before you rebuild

symlink this repository to `/etc`  

```
cd /etc
```

```
sudo rm -rf nixos
```

```
sudo ln -s ~/nixos-server /etc/nixos
```

rebuild your system

```
sudo nixos-rebuild switch
```

# minecraft server config

## plugins

run `scp -r "C:\path\to\your\local\plugins\*" username@your_linux_ip:~/` from the ssh machine to transfer plugins over. for any scp command, follow this syntax

transfer plugins over from `windows` to `linux`

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\plugins\*" server:/var/lib/minecraft/plugins
```

## google drive backup only for minecraft server

from the ssh machine, download rclone, extract rclone.exe into a folder and open a terminal in that folder.
run `.\rclone.exe config`

choose the following

`n, gdrive, drive, *empty*, *empty*, 1, *empty*, n, y, n, y`

create a directory to store rclone.conf and apply rules

```
sudo mkdir -p /root/secrets
```

```
sudo chmod 700 /root/secrets
```

transfer over rclone.conf from the ssh machine to the new directory

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\rclone\*" server:/home/hcg_leo
```

then move it to /root/secrets

```
sudo mv rclone.conf /root/secrets/
```

make sure only a root user can read this file

```
sudo chmod 600 /root/secrets/rclone.conf
```

# media config

## music

scp your music into jellyfin with ``scp``
```
scp -r "C:\Users\Aran Thananjayan\Desktop\backup\music\*" hcg_leo@server:/mnt/storage/music
```
for your music to appear, run this command (replace <*> with playlist name)
```
chmod -R g+rX /mnt/storage/music/<*>
```
## create media backup

skip this step if you either dont need a backup or have a backup

stop services that your going to backup

```
sudo systemctl stop jellyfin radarr sonarr prowlarr qbittorrent seerr
```

compress /var/lib/ of each application into a .tar.gz file

```
sudo tar -czvf ~/media-backup.tar.gz   /var/lib/jellyfin   /var/lib/radarr   /var/lib/sonarr   /var/lib/prowlarr   /var/lib/qBittorrent   /var/lib/seerr
```

transfer over the backup file to ssh machine

```
scp server:/home/hcg_leo/media-backup.tar.gz "C:\Users\Aran\Desktop\backup\nixos-server-files\media"
```

then remove the backup file

```
sudo rm media-backup.tar.gz
```

start services again

```
sudo systemctl start jellyfin radarr sonarr prowlarr qbittorrent seerr
```

## import media backup

transfer over the backup file to your nixos server

```
scp "C:\Users\Aran\Desktop\backup\nixos-server-files\media\media-backup.tar.gz" server:/home/hcg_leo/media-backup.tar.gz
```

stop services you will import backups into

```
sudo systemctl stop jellyfin radarr sonarr prowlarr qbittorrent seerr
```

import backup into each folder (file structure is kept the same in .tar.gz- cool)

```
sudo tar -xzvf ~/media-backup.tar.gz -C /
```

start services again

```
sudo systemctl start jellyfin radarr sonarr prowlarr qbittorrent seerr
```

## vpn for torrenting - im using mullvad

create a wireguard config file from your vpn of choice

transfer over mullvad.conf from the ssh machine to a new directory

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\media-vpn\*" server:/home/hcg_leo
```

then move it to /root/secrets

```
sudo mv mullvad.conf /root/secrets/
```

make sure only a root user can read this file

```
sudo chmod 600 /root/secrets/mullvad.conf
```

use `https://ipleak.net/` to test if your vpn works via torrent address detection, and bind your vpn to qBittorrent
