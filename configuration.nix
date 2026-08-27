{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./minecraft.nix
      ./networking.nix
      ./alias.nix
      ./minecraft-backup.nix
      ./media.nix
      ./vpn-torrent.nix
      ./duckdns.nix
    ];

  environment.systemPackages = with pkgs; [
  neovim
  git
  btop
  ];

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # locales
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  users.users."hcg_leo" = {
    isNormalUser = true;
    description = "Aran Thananjayan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  # services 
  services.openssh.enable = true;
  
  system.stateVersion = "26.05";

  # lid settings
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };


}
