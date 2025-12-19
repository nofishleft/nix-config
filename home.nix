{ config, pkgs, lib, inputs, ...}: {
  imports = [
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
    inputs.nixcord.homeModules.nixcord
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

  config.services.arrpc.enable = true;

  config.programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      # "odin"
    ];
    themes =
      let
        rose-pine-tarball = builtins.fetchTarball {
          url = "https://github.com/rose-pine/zed/archive/refs/tags/v1.3.1.tar.gz";
          sha256 = "1hn3ayppx0bqqypycrzk2v4773z112z6klm9b7yqarlh9v7v3ap2";
        };
      in {
        rose-pine = builtins.readFile "${rose-pine-tarball}/themes/rose-pine.json";
      };
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Rosé Pine";
        light = "Rosé Pine";
      };
      lsp = {
        nix.binary.path_lookup = true;
        ols.binary.path_lookup = true;
      };
      languages = {
        "Odin" = {
          language_servers = ["ols"];
        };
      };
      load_direnv = "shell_hook";
    };
  };

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
        /*betterSettings = {
          enable = true;
          disableFade = true;
          organizeMenu = true;
          eagerLoad = true;
        };*/
        customIdle = {
          enable = true;
          idleTimeout = 0.0;
        };
        gameActivityToggle.enable = true;
        gifPaste.enable = true;
        keepCurrentChannel.enable = true;
        mentionAvatars.enable = true;
        messageLatency.enable = true;
        messageLogger.enable = true;
        mutualGroupDMs.enable = true;
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
        textReplace = {
          enable = true;
          regexRules = [
            {
              find = "/https:\\/\\/x\\.com\\/([^\\/]+\\/status\\/[0-9]+)/";
              replace = "https://vxtwitter.com/$1";
              onlyIfIncludes = "";
            }
            {
              find = "/https:\\/\\/twitter\\.com\\/([^\\/]+\\/status\\/[0-9]+)/";
              replace = "https://vxtwitter.com/$1";
              onlyIfIncludes = "";
            }
          ];
        };
        unindent.enable = true;
        userVoiceShow.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        voiceChatDoubleClick.enable = true;
        viewRaw.enable = true;
        webRichPresence.enable = true;
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
    waybar = {
      enable = true;
      settings.mainBar = {
        output = ["DP-2"];
        layer = "top";
        /*width = 36;*/
        position = "right";
        reload_style_on_change = true;
        modules-left = ["custom/power" "hyprland/workspaces"];
        modules-center = ["mpris" "privacy"];
        modules-right = ["tray" "clock#time" "clock#date"];
        "custom/power" = {
          format = builtins.fromJSON '' "\udb81\udc25" '';
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
          };
          all-outputs = true;
        };
        "mpris" = {
          format = "{status_icon}";
          player-icons = {
            "default" = builtins.fromJSON '' "\udb81\udf5a" '';
            "youtube-music" = builtins.fromJSON '' "\udb81\uddc3" '';
            "google-chrome" = builtins.fromJSON '' "\udb80\udeaf" '';
            "chromium" = builtins.fromJSON '' "\udb80\udeaf" '';
          };
          status-icons = {
            "playing" = builtins.fromJSON '' "\uf04b" '';
            "paused" = builtins.fromJSON '' "\uf04c" '';
            "stopped" = builtins.fromJSON '' "\uf04d" '';
          };
        };
        "privacy" = {
          icon-size = 16;
          icon-spacing = 4;
        };
        "clock#time" = {
          format = "{0:%H}\n{0:%M}";
          tooltip = false;
        };
        "clock#date" = {
          format = "{0:%a%n%b}";
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            weeks-pos = "left";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
            on-click = "mode";
            on-click-right = "shift_reset";
          };
        };
      };
      style = ''
        @define-color base #191724;
        @define-color surface #1f1d2e;
        @define-color overlay #26233a;
        @define-color muted #6e6a86;
        @define-color subtle #908caa;
        @define-color text #e0def4;
        @define-color love #eb6f92;
        @define-color gold #f6c177;
        @define-color rose #ebbcba;
        @define-color pine #31748f;


        * {
          font-size: 16px;
          font-family: CaskaydiaCove NF;
          min-width: 8px;
          padding: 0px;
        }

        window#waybar {
          background: rgba(0,0,0,0);
          color: @text;
          padding-top: 20px;
          padding-bottom: 20px;
        }

        .module {
          margin: 8px 0 8px 0;
          padding: 4px 0 4px 0;

          background: @base;
          border: 3px solid @muted;
          border-radius: 8px;
          min-width: 36px;
          min-height: 36px;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          margin-right: 8px;
          margin-left: 0;
        }

        .modules-left {
          margin-top: 12px;
          margin-bottom: 0;
        }

        .modules-right {
          margin-top: 0;
          margin-bottom: 12px;
        }

        #privacy {
          margin: 8px 0 8px 0;
          padding: 4px 0 4px 0;

          background: @base;
          border: 3px solid @muted;
          border-radius: 8px;

          min-width: 36px;
          min-height: 36px;
        }

        #privacy-item.audio-in {
          margin-left: 10px;
        }

        #privacy-item.screenshare {
          margin-left: 8px;
        }

        #workspaces,
        #custom-power,
        #mpris,
        #tray,
        #clock {
          background: @base;
        }

        #custom-power,
        #mpris {
          padding: 0;
        }

        #custom-power {
          font-size: 24px;
        }

        #tray {
          padding: 8px 0 8px 0;
        }

        #workspaces button {
          padding: 0 0.5em;
          font-size: 24px;
        }

        tooltip {
          border: 1px solid @muted;
          background-color: @surface;
        }
      '';
    };
    wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      style = ''
        window {
          background: rgba(25, 23, 36, 0.5);
        }

        button {
          color: #e0def4;
          background-color: #191724;

          border-radius: 8px;
          border-color: #6e6a86;
          border-style: solid;
          border-width: 3px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;

          margin: 12px;
        }

        button:hover {
          background-color: #1f1d2e;
          border-color: #ebbcba;
          outline-style: none;
        }

        #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
      '';
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
    plugins = /*with pkgs.hyprlandPlugins;*/ [
      # hyprbars
    ];
    settings = {
      input = {
        sensitivity = -0.5;
        follow_mouse = 2;
      };
      source = [ "/home/phush/.config/hypr/rose-pine.conf" ];
      general = {
        monitor = [
          "DP-1, 3440x1440@144, 0x0, 1"
          "DP-2, 1920x1080@60, -1920x360, 1"
        ];
        "border_size" = 3;
        "col.active_border" = "$rose";
        "col.inactive_border" = "$muted";
      };
      decoration = {
        rounding = 5;
      };
      windowrulev2 = (builtins.map (x: "monitor DP-1, ${x}") [
        # DP-1, WS ANY
        "initialClass:kitty"
        "initialClass:steam"
      ]) ++ [
        # WS G, DP-1
        "float, initialClass:yad, initialTitle:SteamTinkerLaunch-OpenSettings"
        "maxsize 1920 1080, workspace:name:G, initialClass:yad"
        "float, workspace:name:G, initialClass:yad"
        "fullscreen, workspace:name:G, initialClass:gamescope"
      ] ++ (builtins.concatMap (x: ["workspace name:G, ${x}" "monitor DP-1, ${x}"]) [
        # WS G, DP-1
        "initialClass:gamescope"
        "initialClass:yad, initialTitle:SteamTinkerLaunch-OpenSettings"
        "initialClass:dota2"
        "initialClass:steam_app_1172710"
      ]) ++ (builtins.concatMap (x: ["workspace name:H silent, ${x}" "monitor DP-2, ${x}"]) [
        # WS H, DP-2
        "initialClass:Slack"
        "initialClass:vesktop"
        "initialClass:com.github.th_ch.youtube_music"
        "initialClass:vivaldi-player.twitch.tv__-Default"
      ]) ++ [
        "float, initialClass:deluge, initialTitle:Add URL"
        "float, initialClass:deluge, initialTitle: Add Torrents (0)"
      ];
      workspace = [
        "name:G, m[DP-1], default:false, rounding:false, decorate:false, shadow:false, gapsin:0, gapsout:0, border:false"
        "name:H, m[DP-2], default:true"
        "1, m[DP-1], default:true"
        "2, m[DP-1], default:false"
        "3, m[DP-1], default:false"
        "4, m[DP-1], default:false"
        "5, m[DP-1], default:false"
        "6, m[DP-1], default:false"
        "7, m[DP-1], default:false"
        "8, m[DP-1], default:false"
        "9, m[DP-1], default:false"
      ];
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow" # Mouse-L
        "$mod, mouse:273, resizewindow" # Mouse-R
      ];
      bind =
        [
          "$mod, Q, killactive"
          #"$mod SHIFT, Q, forcekillactive"
          "$mod, F, fullscreen, 1"
          "$mod SHIFT, F, togglefloating, active"
          "$mod, P, exec, playerctl play-pause"
          "$mod, equal, exec, playerctl volume +0.01"
          "$mod, minus, exec, playerctl volume -0.01"
          "$mod SHIFT, plus, exec, playerctl volume +0.1"
          "$mod SHIFT, underscore, exec, playerctl volume -0.1"
          "$mod, S, exec, hyprshot -z -m active"
          "$mod SHIFT, S, exec, hyprshot -z -m region --clipboard-only"

          # Apps
          "$mod, E, exec, uwsm app -- nemo"
          "$mod, B, exec, uwsm app -- vivaldi"
          "$mod, T, exec, uwsm app -- kitty"
          "$mod, L, exec, uwsm app -- hyprlock"
          "$mod, R, exec, uwsm app -- walker"

          # Focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"

          "$mod, tab, cyclenext"

          "$mod, A, focusmonitor, DP-2"
          "$mod, D, focusmonitor, DP-1"

          # Named Workspaces
          "$mod, G, focusmonitor, DP-1"
          "$mod, G, focusworkspaceoncurrentmonitor, name:G"
          "$mod SHIFT, G, movetoworkspace, name:G"
          "$mod SHIFT, G, moveworkspacetomonitor, name:G DP-1"

          "$mod, H, focusmonitor, DP-2"
          "$mod, H, focusworkspaceoncurrentmonitor, name:H"
          "$mod SHIFT, H, movetoworkspace, name:H"
          "$mod SHIFT, H, moveworkspacetomonitor, name:H DP-2"
        ]
        ++ (
          # WS 3+
          builtins.concatLists (
            builtins.genList (i:
              let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, focusmonitor, DP-1"
                "$mod, code:1${toString i}, focusworkspaceoncurrentmonitor, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, moveworkspacetomonitor, ${toString ws} DP-1"
              ]
            ) 9
          )
        );
      monitor = ", 1920x1080, 0x0, 1";
      plugin = {
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      exec-once = [
        "uwsm app -- walker --gapplication.service"
        "bash /home/phush/.config/hm-impermanent.sh"
        "systemctl --user enable --now hyprpolkitagent.service"
        "uwsm app -- waybar"
        "uwsm app -- hyprnotify"
      ];
    };
  };

  config.services.playerctld.enable = true;

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
    "org/cinnamon/desktop/default-applications/terminal" = {
      exec = "${pkgs.kitty}/bin/kitty";
    };
    "org/virt-manager/virt-manager/connections" = { #winapps
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
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
      gtk-theme-name = "rose-pine";
      gtk-key-theme-name = "rose-pine";
      gtk-icon-theme-name = "rose-pine";
      gtk-cursor-theme-name = "phinger-cursors-light";
    };
    gtk4.extraConfig = {
      gtk-theme-name = "rose-pine";
      #gtk-key-theme-name = "rose-pine";
      gtk-icon-theme-name = "rose-pine";
      gtk-cursor-theme-name = "phinger-cursors-light";
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
