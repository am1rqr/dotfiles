{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-telegram.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-telegram, home-manager, ... }:
  let
    username = "user";
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username; };
        modules = [
          ./hosts/nixos/configuration.nix

          {
            # telegram-desktop is pinned to a separate, newer nixpkgs revision
            nixpkgs.overlays = [
              (final: prev: {
                telegram-desktop = nixpkgs-telegram.legacyPackages.${prev.stdenv.hostPlatform.system}.telegram-desktop;
              })
            ];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = import ./modules/home/home.nix;
          }
        ];
      };
    };
  };
}
