{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # nixos
    rebuild = "sudo nixos-rebuild switch";
    rebuild-flake = "sudo nixos-rebuild switch --flake /home/hcg_leo/nixos-server --impure";
    

    # config
    networking-config = "sudo nvim ~/nixos-server/networking.nix";
    alias-config = "sudo nvim ~/nixos-server/alias.nix";
    config = "sudo nvim ~/nixos-server/configuration.nix";
    
    # minecraft config
    minecraft-config = "sudo nvim ~/nixos-server/minecraft.nix";
    minecraft-backup-config = "sudo nvim ~/nixos-server/minecraft-backup.nix";
    
    # minecraft server
    minecraft-console = "sudo podman exec -it minecraft-server rcon-cli";
    minecraft-console_logs = "sudo journalctl -fu podman-minecraft-server.service";
    minecraft-backup = "sudo systemctl start --no-block minecraft-backup.service";
    minecraft-backup-logs = "sudo journalctl -u minecraft-backup.service -f";
    minecraft-stop = "sudo podman stop -t 60 minecraft-server";

    # media config
    media-config = "sudo nvim ~/nixos-server/media.nix";

    # ip/vpn
    mullvad = "sudo ip netns exec mullvad curl -s https://am.i.mullvad.net/connected";
    public-ip = "curl -4 ifconfig.me";
    
    # other
    reboot = "sudo reboot";
  };
}
