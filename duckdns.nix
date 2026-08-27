{ config, pkgs, ... }:

{
  services.duckdns = {
    enable = true;
    domains = [ "hcg-leo" ];
    tokenFile = "/root/secrets/duckdns-token";
  };
}
