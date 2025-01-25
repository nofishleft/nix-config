{ config, pkgs, lib, inputs, ...}: {
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
    inputs.nixcord.homeManagerModules.nixcord
    /*inputs.impermanence.homeManagerModules.impermanence*/
    ./modules/youtube-music.nix
  ];

  options.hm-impermanent = lib.mkOption {
    type = lib.types.lines;
    default = "#!/env/bin bash";
  };

  config.xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 110;
  };

  config.home = {
    username = "phush";
    homeDirectory = "/home/phush";
    stateVersion = "24.11";
  };

  config.home.sessionVariables = {
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
  };

  /*config.home.persistence."/persistent/home/phush" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".gnupg"
      ".config/gh"
      ".config/vesktop/sessionData"
      ".config/google-chrome"
      ".local/share/keyrings"
      "nix-config"
      "Repos"
    ];
    files = [
      ".gitconfig"
      ".nvidia-settings-rc"
    ];
    allowOther = true;
  };*/

  config.programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
      vencord.enable = false;
    };
    vesktop = {
      enable = true;
      package = pkgs.vesktop;
    };
    vesktopConfig = {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = true;
      splashTheming = true;
      staticTitle = true;
      disableMinSize = true;
    };
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/rose-pine/discord/2651b116511f5c476da7ec9eb413c4d84fa21064/rose-pine.theme.css"
      ];
      transparent = true;
      disableMinSize = true;
      frameless = true;
      plugins = {
        gameActivityToggle.enable = true;
        gifPaste.enable = true;
        keepCurrentChannel.enable = true;
        mentionAvatars.enable = true;
        messageLatency.enable = true;
        messageLogger.enable = true;
        newGuildSettings = {
          enable = true;
          messages = "only@Mentions";
        };
        noUnblockToJump.enable = true;
        permissionsViewer.enable = true;
        petpet.enable = true;
        pictureInPicture.enable = true;
        pinDMs = {
          enable = true;
          pinOrder = "custom";
        };
        plainFolderIcon.enable = true;
        previewMessage.enable = true;
        quickMention.enable = true;
        quickReply.enable = true;
        readAllNotificationsButton.enable = true;
        relationshipNotifier = {
          enable = true;
          notices = true;
          offlineRemovals = true;
          friends = true;
          friendRequestCancels = true;
          servers = true;
          groups = true;
        };
        reverseImageSearch.enable = true;
        reviewDB.enable = true;
        sendTimestamps.enable = true;
        shikiCodeblocks.enable = true;
        showHiddenChannels = {
          enable = true;
          showMode = "muted";
        };
        showMeYourName = {
          enable = true;
          mode = "nick-user";
        };
        showTimeoutDuration.enable = true;
        silentMessageToggle.enable = true;
        silentTyping = {
          enable = true;
          showIcon = true;
          contextMenu = true;
          isEnabled = false;
        };
        unindent.enable = true;
        userVoiceShow.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        voiceChatDoubleClick.enable = true;
        viewRaw.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };

  config.programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
    };
    hyprcursor-phinger.enable = true;
    hyprpanel = {
      enable = true;
      overlay.enable = true;
      #systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      theme = "rose_pine";
      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systray" "notifications" ];
          };
        };
      };
      settings = {
        wallpaper.enable = false;
        scalingPriority = "hyprland";
        bar.launcher.autoDetectIcon = true;
        bar.workspaces.show_icons = true;
        menus.clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.unit = "metric";
        };
        menus.dashboard.powermenu.avatar.image = "/home/phush/.config/avatars/meiyaSit.png";
        menus.dashboard.directories.enabled = false;
        menus.dashboard.stats.enable_gpu = false;
        menus.dashboard.shortcuts.left = {
          shortcut1 = {
            icon = builtins.fromJSON '' "\uf268" '';
            tooltip = "Chrome";
            command = "uwsm app -- google-chrome-stable";
          };
          shortcut2 = {
            icon = builtins.fromJSON '' "\uDB80\uDF86" ''; # F0386
            tooltip = "YT Music";
            command = "uwsm app -- youtube-music";
          };
          shortcut3 = {
            icon = builtins.fromJSON '' "\uf1ff" '';
            tooltip = "Discord";
            command = "uwsm app -- vesktop";
          };
          shortcut4 = {
            icon = builtins.fromJSON '' "\uf422" '';
            tooltip = "Search";
            command = "uwsm app -- walker";
          };
        };
        menus.dashboard.shortcuts.right = {
          shortcut1 = {
            icon = builtins.fromJSON '' "\uF1FB" '';
            tooltip = "Color Picker";
            command = "sleep 0.5 && uwsm app -- hyprpicker -a";
          };
          shortcut3 = {
            icon = builtins.fromJSON '' "\uDB80\uDD00" '';
            tooltip = "Screenshot";
            command = "sleep 0.5 && uwsm app -- hyprshot --freeze -m active";
          };
        };
        theme.bar.transparent = true;
        theme.font = {
          name = "CaskaydiaCove NF";
          size = "16px";
        };
      };
    };
  };

  config.home.file."./.config/hm-impermanent.sh" = {
    text = config.hm-impermanent;
  };

  config.home.file."./.config/hypr/rose-pine.conf" = {
    source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/rose-pine/hyprland/6898fe967c59f9bec614a9a58993e0cb8090d052/rose-pine.conf";
      sha256 = "0q4zna3njimn2ffaincjcxyiyx8qlz625q6n4k3qbxwqbmvdlcc2";
    };
  };

  config.home.pointerCursor = {
    name = "phinger-cursor-light";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
  };

  config.wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = with pkgs.hyprlandPlugins; [
      hyprbars
    ];
    settings = {
      input.sensitivity = -0.5;
      source = [ "/home/phush/.config/hypr/rose-pine.conf" ];
      general = {
        monitor = [
          "DP-1, 3440x1440@144, 0x0, 1"
          "DP-2, 1920x1080@60, -1920x360, 1"
        ];
        "col.active_border" = "$rose $pine $love $iris 90deg";
        "col.inactive_border" = "$muted";
      };
      decoration = {
        rounding = 5;
        /*active_opacity = 1.0;
        inactive_opacity = 0.8;
        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = true;
        };*/
      };
      windowrulev2 = [
        "workspace name:gaming, initialClass:gamescope"
        "workspace name:gaming, initialClass:yad, initialTitle:SteamTinkerLaunch-OpenSettings"
        "workspace 3, initialTitle:^(Flawless Widescreen.*)"
        "float, initialClass:yad, initialTitle:SteamTinkerLaunch-OpenSettings"
        "maxsize 480 720, workspace:name:gaming, initialClass:yad"
        "float, workspace:name:gaming, initialClass:yad"
        "fullscreen, workspace:name:gaming, initialClass:gamescope"
      ];
      workspace = [
        "name:gaming, m[DP-1], rounding:false, decorate:false, shadow:false, gapsin:0, gapsout:0, border:false"
        "1, m[DP-1], default:true"
        "2, m[DP-2], default:true"
      ];
      "$mod" = "SUPER";
      bind =
        [
          "$mod, E, exec, uwsm app -- nemo"
          "$mod, F, exec, uwsm app -- google-chrome-stable"
          "$mod, Q, exec, uwsm app -- kitty"
          "$mod, L, exec, uwsm app -- hyprlock"
          "$mod, R, exec, uwsm app -- walker"
          "$mod, G, focusworkspaceoncurrentmonitor, name:gaming"
          "$mod SHIFT, G, movetoworkspace, name:gaming"
        ]
        ++ (
          # Workspaces
          builtins.concatLists (
            builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, focusworkspaceoncurrentmonitor, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      monitor = ", 1920x1080, 0x0, 1";
      plugin = {
        hyprbars = {
          /*bar_height = 20;
          bar_title_enabled = true;
          hyprbars-button = "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive";*/
          bar_blur = true;
          bar_height = 24;#38;
          bar_color = "0xdd191724";
#          bar_color = "rgba(1e1e1edd)";
          "col.text" = "$rose";#"0xffebbcba";#"$rose";
          bar_text_size = 10;#12;
          bar_text_font = "Caskaydia Cove Bold";
          bar_button_padding = 8;#12;
          bar_padding = 10;
          bar_precedence_over_border = true;
          bar_part_of_window = true;
          hyprbars-button = [
            "rgb(FF605C), 14, , hyprctl dispatch killactive"
            "rgb(FFBD44), 14, , hyprctl dispatch fullscreen 2"
            "rgb(00CA4E), 14, , hyprctl dispatch togglefloating"
          ];
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      exec-once = [
        "uwsm app -- hyprpaper"
        "uwsm app -- walker --gapplication.service"
        "bash /home/phush/.config/hm-impermanent.sh"
        "systemctl --user enable --now hyprpolkitagent.service"
      ];
      # exec-once = ["swww-daemon"];
      # exec-once = ["wpaperd -d"];
    };
  };

  config.services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      
      preload = [
 #       "/home/phush/.config/wallpapers/110bpm_1080p.png"
        "/home/phush/.config/wallpapers/cyberfomx_1080p.png"
      ];

      wallpaper = [
#        ", /home/phush/.config/wallpapers/110bpm_1080p.png"
        ", /home/phush/.config/wallpapers/cyberfomx_1080p.png"
      ];
    };
  };

  config.home.file."./.config/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  config.home.file."./.config/avatars" = {
    source = ./avatars;
    recursive = true;
  };

  config.programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
        no_fade_out = false;
      };
      background = {
        path = "/home/phush/.config/wallpapers/cyberfomx_1080p.png";
        color = "rgba(0, 0, 0, 1.0)";
        blur_passes = 2;
        blur_size = 7;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
        crossfade_time = 1;
      };
      label = [{
        position = "0, 200";
        text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 95;
        font-family = "Jetbrains Mono Extrabold";
        halign = "center";
        valign = "center";
      }];
      input-field = [{
        size = "200, 60";
        position = "0, -200";
        dots_center = true;
        dots_size = 0.2;
        dots_spacing = 0.35;
        font_color = "rgba(202, 211, 245, 1.0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        outer_color = "rgba(0, 0, 0, 0)";
        check_color = "rgb(204, 136, 34)";
        outline_thickness = 2;
        placeholder_text = "<span foreground=\"##cdd6f4\">Password...</span>";
        hide_input = false;
        fade_on_empty = false;
        shadow_passes = 0;
        rounding = -1;
      }];
    };
  };

  config.dconf.settings = {
    "org.gnome.desktop.interface" = {
      gtk-theme = "rose-pine";
      icon-theme = "rose-pine";
      #color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "rose-pine";
      icon-theme = "rose-pine";
      cursor-theme = "phinger-cursors-light";
      #color-scheme = "prefer-dark";
    };
  };
  
  config.gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };
    font = {
      name = "caskaydia-cove";
      package = pkgs.nerd-fonts.caskaydia-cove;
    };
    gtk3.extraConfig = {
      #gtk-application-prefer-dark-theme = true;
      gtk-key-theme-name = "rose-pine";
      gtk-icon-theme-name = "rose-pine";
    };
  };

  /*config.qt = {
    enable = true;
    platformTheme = "gnome";
    style = "rose-pine";
  };*/

  config.programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require('lspconfig').nil_ls.setup({})
        '';
      }
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require('mini.icons').setup({})
          require('mini.git').setup({})
          local diff = require('mini.diff')
          diff.setup({ source = diff.gen_source.save() })
        '';
      }
    ];
    extraConfig = ''
      set autoindent
      set number
      set cursorline
      
      autocmd FileType nix setlocal smartindent shiftwidth=2 tabstop=2 softtabstop=0 expandtab signcolumn=yes:1
    '';
    extraLuaConfig = ''
    '';
  };

  config.programs.kitty = {
    enable = true;
    themeFile = "rose-pine";
    font = {
      name = "caskaydia-cove";
      size = 14;
      package = pkgs.nerd-fonts.caskaydia-cove;
    };
  };

  config.programs.starship = {
    enable = true;
    # enableNushellIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  config.programs.carapace = {
    enable = true;
    # enableNushellIntegration = true;
  };

  config.programs.nushell = {
    enable = false;
    extraConfig = ''
      let carapace_completer = {|spans|
        carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
        buffer_editor: 'nvim'
        show_banner: false
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: 'fuzzy'
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
        }
      };
      $env.PATH = ($env.PATH |
        split row (char esep) |
        prepend /home/phush/.apps/ |
        append /usr/bin/env
      )
      if (uwsm check may-start | complete).exit_code == 0 {
        exec uwsm start =S hyprland-uwsm.desktop
      }
    '';
  };

  config.home.file."./.config/btop/themes/rose-pine.theme" = {
    source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/rose-pine/btop/6d6abdc0a8c8bcd3b056d9fe3256cfbe7e359312/rose-pine.theme";
      sha256 = "1injry07mx683f1cy2ks73rdiv4dfi8b5ija8bq6adhbgcw7b1h8";
    };
  };

  config.programs.btop = {
    enable = true;
    settings = {
      color_theme = "rose-pine";
    };
  };

  config.programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.wlrobs
    ];
  };

  config.programs.youtube-music = {
    enable = true;
    settings = {
      appVisible = true;
      tray = true;
      autoUpdates = true;
      disableHardwareAcceleration = false;
    };
    themes = [ "rose-pine" ];
    plugins = {
      precise-volume = {
        enabled = true;
        steps = 1;
        arrowsShortcut = true;
        globalShortcuts = {};
        savedVolume = 25;
      };
      in-app-menu = {
        enabled = true;
        hideDOMWindowControls = true;
      };
      exponential-volume = {
        enabled = true;
      };
      compact-sidebar = {
        enabled = true;
      };
      # On start, select last played song, but don't autoplay it
      disable-autoplay = {
        enabled = true;
        applyOnce = true;
      };
      video-toggle = {
        mode = "custom";
      };
      notifications = {
        enabled = false;
      };
    };
    extraConfig = {
      resumeOnStart = true;
    };
  };
}
