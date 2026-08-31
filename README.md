# nixos server configuration

*self host!!*

![nixos](https://img.shields.io/badge/nixos-26.05-5277c3?style=for-the-badge&logo=nixos) ![linux](https://img.shields.io/badge/linux-fcc624?style=for-the-badge&logo=linux) ![openssh](https://img.shields.io/badge/openssh-enabled-000000?style=for-the-badge&logo=openssh)

custom nixos server running on a hp laptop 15s-fq2xxx - just a minecraft and media server.

### overview

```
.
├── .gitignore
├── abyss.nix
├── alias.nix
├── configuration.nix
├── duckdns.nix
├── google-drive-backup.nix
├── media.nix
├── minecraft-backup.nix
├── minecraft.nix
├── networking.nix.template
└── vpn-torrent.nix.template
```

### the files and what they configure

- `configuration.nix` — entry point, imports everything below plus `hardware-configuration.nix` and `networking.nix`
- `abyss.nix` — css code for jellyfin theme
- `alias.nix` — shell aliases for rebuilding, editing configs and managing the minecraft server
- `duckdnd.nix` — static ip for the whole server
- `google-drive-backup.nix` — backup personal google drive to local server
- `minecraft.nix` — a paper server in a podman container, 6gb ram, ports 25565/tcp + 24454/udp
- `minecraft-backup.nix` — nightly timer: stop the server, rclone sync `/var/lib/minecraft` to google drive, start it back up
- `media.nix` — jellyfin + qbittorrent, plus the shared `media` group and storage under `/mnt/storage`
- `networking.nix.template` — copy to `networking.nix`, fill in your wifi
- `vpn-torrent.nix.template` — copy to `vpn-torrent.nix`, fill in your vpn, same idea

### pre-install

setup wifi via `nmtui`, then add git and enable openssh in `sudo nano /etc/nixos/configuration.nix`, then `sudo nixos-rebuild switch`

### install

```
cd ~
git clone https://github.com/hcg-leo/nixos-server
```

```
cp nixos-server/networking.nix.template nixos-server/networking.nix
nano nixos-server/networking.nix
```

```
cp ~/nixos-server/vpn-torrent.nix.template ~/nixos-server/vpn-torrent.nix
nano ~/nixos-server/vpn-torrent.nix
```

```
cp /etc/nixos/hardware-configuration.nix ~/nixos-server
```

```
cd /etc
sudo rm -rf nixos
sudo ln -s ~/nixos-server /etc/nixos
sudo nixos-rebuild switch
```

## minecraft server config

### plugins

same `scp -r "local\path\*" user@ip:path` syntax applies to every transfer below. windows → linux example:

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\plugins\*" hcg_leo@server:/var/lib/minecraft/plugins
```

### google drive backup

download rclone on the ssh machine, run `.\rclone.exe config`, choose:
`n, gdrive, drive, *empty*, *empty*, 1, *empty*, n, y, n, y`

```
sudo mkdir -p /root/secrets
sudo chmod 700 /root/secrets
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\rclone\*" hcg_leo@server:/home/hcg_leo
sudo mv rclone.conf /root/secrets/
sudo chmod 600 /root/secrets/rclone.conf
```

## media config

### music

```
scp -r "C:\Users\Aran Thananjayan\Desktop\backup\music\*" hcg_leo@server:/mnt/storage/music
chmod -R g+rX /mnt/storage/music/<*>
```
(replace `<*>` with the playlist name so it shows up)

### backup

skip if you don't need one or already have one:

```
sudo systemctl stop jellyfin radarr sonarr prowlarr qbittorrent seerr
sudo tar -czvf ~/media-backup.tar.gz /var/lib/jellyfin /var/lib/radarr /var/lib/sonarr /var/lib/prowlarr /var/lib/qBittorrent /var/lib/seerr
scp hcg_leo@server:/home/hcg_leo/media-backup.tar.gz "C:\Users\Aran\Desktop\backup\nixos-server-files\media"
sudo rm media-backup.tar.gz
sudo systemctl start jellyfin radarr sonarr prowlarr qbittorrent seerr
```

### restore

```
scp "C:\Users\Aran\Desktop\backup\nixos-server-files\media\media-backup.tar.gz" hcg_leo@server:/home/hcg_leo/media-backup.tar.gz
sudo systemctl stop jellyfin radarr sonarr prowlarr qbittorrent seerr
sudo tar -xzvf ~/media-backup.tar.gz -C /
sudo systemctl start jellyfin radarr sonarr prowlarr qbittorrent seerr
```

file structure is kept the same in the `.tar.gz` — cool.

### vpn for torrenting - im using mullvad

create a wireguard config from your vpn of choice, then:

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\media-vpn\*" hcg_leo@server:/home/hcg_leo
sudo mv mullvad.conf /root/secrets/
sudo chmod 600 /root/secrets/mullvad.conf
```

test at `https://ipleak.net/`, bind your vpn to qBittorrent
