{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
  };

  outputs = { self, nixpkgs, vpn-confinement, ... }:
  {
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        vpn-confinement.nixosModules.default
      ];
    };
  };
}

