{
  description = "My flake";
  
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor-phinger = {
      url = "github:Jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-apps = {
      url = "github:nofishleft/nix-apps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-nixos-tty = {
      url = "github:nofishleft/rose-pine-nixos-tty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nikpkgs.config.allowUnfree = true;
    nixosModules.default = { config, pkgs, lib, ... }: {
      options.services.wluma.enable = lib.mkEnableOption "wluma";
      config = lib.mkIf config.services.wluma.enable {
        systemd.user.services.wluma = {
          enable = true;
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.wluma}/bin/wluma";
          };
        };
      };
    };
    nixosConfigurations = (builtins.mapAttrs (
      name: value: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({config, pkgs, ...}: {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [(final: prev: {
              tahoma2d = inputs.nix-apps.packages."x86_64-linux".tahoma2d;
              jammer = inputs.nix-apps.packages."x86_64-linux".jammer-appimage;
              gamescope = inputs.nix-apps.packages."x86_64-linux".gamescope;
            })];
          })
          ./hardware-${value}.nix
          ./config-${value}.nix
          ./locale.nix
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          self.nixosModules.default
        ];
      }
    ) {
      zenbook = "ux433fn";
      north = "north";
    });
    devShells."x86_64-linux" = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    import ./devshell.nix { inherit pkgs; };
  };
}
