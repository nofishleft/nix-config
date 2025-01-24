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
    /*impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
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
    nixosConfigurations.zenbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-ux433fn.nix
        ./config-ux433fn.nix
        ./locale.nix
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        self.nixosModules.default
      ];
    };
    nixosConfigurations.north = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-north.nix
        ./config-north.nix
        ./locale.nix
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        self.nixosModules.default
      ];
    };
    devShells."x86_64-linux" = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    import ./devshell.nix { inherit pkgs; };
  };
}
