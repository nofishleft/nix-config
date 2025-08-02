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
    gaming = lib.mkEnableOption "gaming";
  };

  config.nix.settings = {
    substituters = [
      "http://192.168.0.64:8080/phush-north"
      "https://cache.nixos.org"
    ];
    trusted-substituters = [
      "http://192.168.0.64:8080/phush-north"
      "https://hydra.nixos.org/"
    ];
    trusted-users = [
      "root"
      "phush"
    ];
    trusted-public-keys = [
      "phush-north:pYv0MU0I0VhtVPX140EHVL+3tujEJYVwYP5s7bt1bHM= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
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

  config.boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  config.nixpkgs.config.allowUnfree = true;
  config.nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  config.security.polkit.enable = true;

  # Bootloader.
  /*config.boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };*/

  config.boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = pkgs.fetchzip {
        url = "https://github.com/rose-pine/grub/archive/436d8bedf613ec03955845c9f699cf36f3dd51f8.zip";
        sha256 = "3HhlJQiVkaXdNxU7CIvLuY80HQPURZxCzXLInBnBtmk=";
      };
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  imports = [
    inputs.rose-pine-nixos-tty.nixosModules.default
  ];

  config.rose-pine-nixos-tty = {
    enable = true;
    variant = "rose-pine";
  };

  /*config.console.colors = [
    "191724"
	  "eb6f92"
	  "9ccfd8"
	  "f6c177"
	  "31748f"
	  "c4a7e7"
	  "ebbcba"
	  "e0def4"
	  "26233a"
	  "eb6f92"
	  "9ccfd8"
	  "f6c177"
	  "31748f"
	  "c4a7e7"
	  "ebbcba"
	  "e0def4"
  ];*/

  config.networking = {
    hostName = config.hostName;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "wpa_supplicant";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  config.users.users.phush = {
    isNormalUser = true;
    description = "phush";
    extraGroups = [ "networkmanager" "wheel" "i2c" "video" ];
    packages = /*with pkgs;*/ [];
    shell = pkgs.bash;
#    shell = pkgs.nushell;
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

    # Util
    gparted
    ntfs3g

    # Nix Lsps
    nixd
    nil

    wineWowPackages.waylandFull

    # Git things
    git
    gh
    gitui
    delta
    gnupg
    pinentry-tty
    gitkraken

    # Cloud
    s3cmd
    dvc-with-remotes

    appimage-run

    # Stuff for Tray/Bar
    playerctl
    pasystray
      pavucontrol
    networkmanagerapplet

    phinger-cursors

    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland

    # Vulkan
    # vulkan-loader

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
    # Gui elevation
    hyprpolkitagent
    # Logout menu
    wlogout
    # Widgets
    eww

    unzip

    # CLI Documentation search for Nix
    manix

    # Cli
    pciutils
    wget
    jq
    ddcutil
    fastfetch
    wtwitch
    streamlink
    gpu-screen-recorder
    eza # ls alternative
    dust # du alternative
    bat # cat alternative
    ripgrep # grep alternative
    yt-dlp
    ytdl-sub
    dysk # df alt

    # Tui Apps
    vim
    neovim
    btop
    ncdu
    twitch-tui
    ytui-music
    jammer
    ytermusic
    gitui

    adwaita-icon-theme
    gtk3

    # Gui Apps
    youtube-music
    obs-studio
    slack
    anydesk
    chatterino7
    tahoma2d # Animation editor
    kicad # PCB Creation
    cemu # Wii U Emulation
    audacity # Music editor
    openscad
    godot # Game engine
    godot-mono
    mpv # Video player
    vivaldi # Browser
    insync # GDrive Sync
    libreoffice-qt6-fresh
    zed-editor
    openshot-qt # Video editor
    drawio # Diagrams
    drawing # Gnome image editor
    blender
    blockbench
    beeper # Messaging
    handbrake # Video transcoding
    geary # Email
    kdePackages.okular # Pdf
    onlyoffice-desktopeditors # Office suite
    wpsoffice
    legcord
    supersonic-wayland # Jellyfin client
    jellyfin-media-player
    qbittorrent
    parabolic

    #nextcloud-client
    attic-client

    # Themes
    (rose-pine-gtk-theme.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes/rose-pine{,-dawn,-moon}/

        variants=("rose-pine" "rose-pine-dawn" "rose-pine-moon")
        for n in "''${variants[@]}"; do
          cp -r $src/gtk3/"''${n}"-gtk/* $out/share/themes/"''${n}"
        done

        runHook postInstall
      '';
    }))
    rose-pine-icon-theme
  ] ++ ( with pkgs.jetbrains; [
    clion
    rust-rover
    gateway
  ]) ++ (with pkgs; lib.optionals config.backlightControl [
    wluma
    brightnessctl
    ddcutil
  ]) ++ (with pkgs; lib.optionals config.gaming [
    steamtinkerlaunch
    prismlauncher
    bottles
    lutris
    protonup-qt
    protonplus
    protonup-ng
    wine-staging
    winetricks
    protontricks
  ]);

  config.programs.steam.enable = config.gaming;
  config.programs.gamescope.enable = config.gaming;
  config.programs.gamemode.enable = config.gaming;
  config.programs.dconf.enable = true;

  config.programs.appimage = {
    enable = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
        pkgs.libxcrypt-legacy
      ];
    };
  };

  config.xdg.mime = {
    defaultApplications = {
      "inode/directory" = "nemo.desktop";
      "application/x-gnome-saved-search" = "nemo.desktop";
    };
  };

  config.programs.direnv.enable = true;

  #config.programs.steam = {
  #  enable = true;
  #};

  config.environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM="wayland;xcb";
    ELECTRON_OZONE_PLATFORM_HINT="wayland";
    CLUTTER_BACKEND="wayland";
    SDL_VIDEODRIVER="wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CONFIG_HOME = "$HOME/.config";
    GTK_THEME = "rose-pine";
    HYPRCURSOR_THEME = "phinger-cursors-light";
    HYPRCURSOR_SIZE = "24";
  } // lib.mkIf config.useNvidiaGpu {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  config.qt = {
    enable = true;
    platformTheme = "gnome";
    style = "breeze";
  };

/*  config.environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
    '';
  };
*/
  config.fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    corefonts
    vistafonts
  ] ++ (builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts));


  config.hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
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
  };/* // lib.mkIf (!config.useNvidiaGpu) {
    graphics = {
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };*/

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

  config.services.gnome.gnome-keyring.enable = true;

  config.system.stateVersion = "24.11";

}
