# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
    };
    useNvidiaGpu = lib.mkEnableOption "useNividaGpu";
    nvidiaBusIds = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
  };

  config.nixpkgs.config.allowUnfree = true;  

  # Bootloader.
  config.boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  config.networking = {
    hostName = config.hostName;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "wpa_supplicant";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  config.users.users.phush = {
    isNormalUser = true;
    description = "phush";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  
  config.home-manager = {
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users = {
      "phush" = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  config.environment.systemPackages = with pkgs; [
    vim
    pciutils
    wget
    git
    google-chrome
    phinger-cursors
    waybar
    networkmanagerapplet
    # Notifications
    hyprnotify
    libnotify
    # Terminal
    kitty
    # Wallpaper
    hyprpaper
    # Runner
    walker
    # Screenshot
    hyprshot
    # Color picker
    hyprpicker

    unzip

    #File explorer
    nemo-with-extensions

    neovim

    hyprland

    # CLI Documentation search for Nix
    manix

    jq

    youtube-music

    gh
    neofetch
  ];

  config.environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CONFIG_HOME = "$HOME/.config";
  } // (if config.useNvidiaGpu then {
    LIBVA_DRIVE_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  } else {

  });

  config.environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
    '';
  };

  config.fonts.packages = [
    pkgs.font-awesome
    pkgs.powerline-fonts
    pkgs.powerline-symbols
  ] ++ (builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts));


  config.hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  } // (if config.useNvidiaGpu then {
    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      prime = {
        offload.enable = true;
        # intelBusId = "PCI:0:2:0";
        # nvidiaBusId = "PCI:2:0:0";
      } // config.nvidiaBusIds;
    };
  } else {
  });

  config.programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;
  };

  config.services = {
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    pipewire = {
      enable = true;
      jack.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    getty.autologinUser = "phush";
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = (if config.useNvidiaGpu then [
        "nvidia"
      ] else [
        "amdgpu"
      ]);
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  config.xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  config.system.stateVersion = "24.11";

}
