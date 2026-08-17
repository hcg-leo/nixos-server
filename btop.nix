{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.btop ];

  environment.etc = {
    "xdg/btop/btop.conf".source = ./.config/btop/btop.conf;
    "xdg/btop/themes".source = ./.config/btop/themes;
  };
}
