# nixos server configuration

*self host!!* - custom nixos server running on a hp laptop 15s-fq2xxx

### overview - duckdns, google drive backup, jellyfin + torrent + vpn binded to just qbittorrent, minecraft backup to google drive, minecraft server and obsidian sync 

```
.
├── .gitignore
├── abyss.nix
├── alias.nix
├── configuration.nix
├── duckdns.nix
├── google-drive-backup.nix
├── media.nix
├── # minecraft-backup.nix
├── # minecraft.nix
├── networking.nix.template
├── obsidian.nix.template
└── vpn-torrent.nix.template
```

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
cp nixos-server/obsidian.nix.template nixos-server/obsidian.nix
nano nixos-server/obsidian.nix
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

## duckdns

```
sudo mkdir -p /root/secrets
vim duckdns-token
sudo mv duckdns-token /root/secrets
sudo chmod 600 /root/secrets/duckdns-token
```
## minecraft server config

### plugins

same `scp -r "local\path\*" user@ip:path` syntax applies to every transfer below. windows to linux example:

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\plugins\*" hcg_leo@hcg-leo.duckdns.org:/var/lib/minecraft/plugins
```

### google drive backup

download rclone on the ssh machine, run `.\rclone.exe config`, choose:
`n, gdrive, drive, *empty*, *empty*, 1, *empty*, n, y, n, y`

```
sudo chmod 700 /root/secrets
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\rclone\*" hcg_leo@hcg-leo.duckdns.org:/home/hcg_leo
sudo mv rclone.conf /root/secrets/
sudo chmod 600 /root/secrets/rclone.conf
```

## media config - file transformation, intro skipper, media bar

### transfering music files (use spotDL)

```
scp -r "C:\Users\Aran Thananjayan\Desktop\backup\music\*" hcg_leo@hcg-leo.duckdns.org:/mnt/storage/music
chmod -R g+rX /mnt/storage/music/*
```
(replace `*` with the playlist name)

### backup

skip if you don't need one or already have one:

```
sudo systemctl stop jellyfin qbittorrent
sudo tar -czvf ~/media-backup.tar.gz /var/lib/jellyfin /var/lib/qBittorrent
scp hcg_leo@hcg-leo.duckdns.org:/home/hcg_leo/media-backup.tar.gz "C:\Users\Aran\Desktop\backup\nixos-server-files\media"
sudo rm media-backup.tar.gz
sudo systemctl start jellyfin qbittorrent
```

### restore

```
scp "C:\Users\Aran\Desktop\backup\nixos-server-files\media\media-backup.tar.gz" hcg_leo@hcg-leo.duckdns.org:/home/hcg_leo/media-backup.tar.gz
sudo systemctl stop jellyfin qbittorrent
sudo tar -xzvf ~/media-backup.tar.gz -C /
sudo systemctl start jellyfin qbittorrent
```

file structure is kept the same in the `.tar.gz` - cool.

### vpn for torrenting - im using mullvad

create a wireguard config from your vpn of choice, then:

```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\media-vpn\*" hcg_leo@hcg-leo.duckdns.org:/home/hcg_leo
sudo mv mullvad.conf /root/secrets/
sudo chmod 600 /root/secrets/mullvad.conf
```

test at `https://ipleak.net/`, bind your vpn to qBittorrent
