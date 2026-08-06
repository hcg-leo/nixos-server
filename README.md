<div align="center">
  <h1> nixos server configuration </h1>
  <p><i>embrace declarative.</i></p>
  
  ![NixOS](https://img.shields.io/badge/NixOS-26.05-5277C3.svg?style=for-the-badge&logo=NixOS&logoColor=white)
  ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
  ![OpenSSH](https://img.shields.io/badge/OpenSSH-Secure-000000?style=for-the-badge&logo=OpenSSH&logoColor=white)
</div>

### pre-install
go to ``nmtui`` and setup wifi

run ``sudo nano /etc/nixos/configuration.nix`` and add both git and enable openSSH 

then ``sudo nixos-rebuild switch``


### install
clone this repository <br/>
```
cd ~
```
```
git clone https://github.com/hcg-leo/nixos-server
```
go to ``nixos-server/networking.nix`` and setup wifi (in the cloned repository) <br/>
copy networking.nix.template to networking.nix
```
cp nixos-server/networking.nix.template nixos-server/networking.nix
```
```
nano nixos-server/networking.nix
```
copy ``/etc/nixos/hardware-configuration.nix`` to ``/nixos-server/hardware-optimization``
```
cp /etc/nixos/hardware-configuration.nix ~/nixos-server/hardware-optimization
```
symlink this repository to ``/etc`` <br/>
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
run ``scp -r "C:\path\to\your\local\plugins\*" username@your_linux_ip:~/`` from the SSH machine to transfer plugins over. for any scp command, follow this syntax

transfer plugins over from ``windows`` to ``linux``
```
scp -r "C:\Users\Aran\Desktop\backup\nixos-server-files\plugins\*" server:/var/lib/minecraft/plugins
```

## google drive backup only for minecraft server

from the SSH machine, download rclone, extract rclone.exe into a folder and open a terminal in that folder.
run ``.\rclone.exe config``

choose the following

`n, gdrive, drive, *EMPTY*, *EMPTY*, 1, *EMPTY*, n, y, n, y`

create a directory to store rclone.conf and apply rules
```
sudo mkdir -p /root/secrets
```
```
sudo chmod 700 /root/secrets
```
transfer over rclone.conf from SSH machine to new directory
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
transfer over the backup file to SSH machine
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

transfer over rclone.conf from SSH machine to new directory
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
use ``https://ipleak.net/`` to test if your vpn works via torrent address detection, and bind your vpn to qBittorrent
