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
    backlightControl = lib.mkEnableOption "enable backlight control";
  };

/*  config.nixpkgs.overlays = [ (final: prev: {
    rose-pine-gtk-theme = prev.rose-pine-gtk-theme.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "rose-pine";
        repo = "gtk";
        rev = "d0d7815f0af2facd3157e005cd7c606d4f28d881";
        sha256 = "vCWs+TOVURl18EdbJr5QAHfB+JX9lYJ3TPO6IklKeFE=";
      };
    });
  }) ];*/

  config.nixpkgs.config.allowUnfree = true;
  config.nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    shell = pkgs.nushell;
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
    # Shells
    bash
    nushell
  
    # Editor
    vim
    neovim

    # Util
    pciutils
    wget
    jq # Helps with json files
    ddcutil

    # Git things
    git
    gh

    google-chrome
    phinger-cursors
    networkmanagerapplet

    greetd.greetd
    # Window title bar
    waybar
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
    # Window manager
    hyprland
    #File explorer
    nemo-with-extensions

    unzip

    # CLI Documentation search for Nix
    manix

    neofetch
    btop

    # Gui Apps
    youtube-music
    obs-studio

    # Themes
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ] ++ ( with pkgs.jetbrains; [
    clion
    rust-rover
  ]) ++ lib.optionals config.backlightControl [  pkgs.wluma pkgs.brightnessctl pkgs.ddcutil ];

  config.environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CONFIG_HOME = "$HOME/.config";
    GTK_THEME = "rose-pine";
  } // lib.mkIf config.useNvidiaGpu {
    LIBVA_DRIVE_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

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
  } // lib.mkIf config.useNvidiaGpu {
    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      prime = {
        offload.enable = true;
      } // config.nvidiaBusIds;
    };
  };

  # Required for home.persistence.*.allowOther
  config.programs.fuse.userAllowOther = true;

  config.programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
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
    };
  };

  config.services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 1;
      };
      default_session = {
        command = "agreety --cmd /bin/sh";
        user = "greeter";
      };
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "phush";
      };
    };
  };

  config.xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  config.system.stateVersion = "24.11";

}
