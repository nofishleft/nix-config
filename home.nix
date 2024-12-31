{ pkgs, inputs, ...}: {
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
    inputs.nixcord.homeManagerModules.nixcord
  ];

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 800;
  };
  home = {
    username = "phush";
    homeDirectory = "/home/phush";
    # sessionVariables = {
    #  NIXOS_OZONE_WL = "1";
    #  LIBVA_DRIVER_NAME = "nvidia";
    #  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #  XDG_CONFIG_HOME = "/home/phush/.config";
    #};
    stateVersion = "24.11";
  };

  programs.nixcord = {
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
        showMeYourName.enable = true;
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

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
    };
    hyprcursor-phinger.enable = true;
    hyprpanel = {
      enable = true;
      systemd.enable = true;
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
            command = "google-chrome-stable";
          };
          shortcut2 = {
            icon = builtins.fromJSON '' "\uDB80\uDF86" ''; # F0386
            tooltip = "YT Music";
            command = "youtube-music";
          };
          shortcut3 = {
            icon = builtins.fromJSON '' "\uf1ff" '';
            tooltip = "Discord";
            command = "vesktop";
          };
          shortcut4 = {
            icon = builtins.fromJSON '' "\uf422" '';
            tooltip = "Search";
            command = "rofi -show drun";
          };
        };
        menus.dashboard.shortcuts.right = {
          shortcut1 = {
            icon = builtins.fromJSON '' "\uF1FB" '';
            tooltip = "Color Picker";
            command = "sleep 0.5 && hyprpicker -a";
          };
          shortcut3 = {
            icon = builtins.fromJSON '' "\uDB80\uDD00" '';
            tooltip = "Screenshot";
            command = "sleep 0.5 && hyprshot --freeze -m active";
          };
        };
        theme.bar.transparent = true;
        theme.font = {
          name = "CaskaydiaCove NF";
          size = "16px";
        };
      };
    };
    kitty = { enable = true; };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprbars
    ];
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, google-chrome-stable"
          "$mod, Q, exec, kitty"
          "$mod, L, exec, hyprlock"
        ]
        ++ (
          # Workspaces
          builtins.concatLists (
            builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      monitor = ", 1920x1080, 0x0, 1";
      plugin = {
        hyprbars = {
          bar_height = 20;
          bar_title_enabled = true;
          hyprbars-button = "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive";
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      exec-once = ["hyprpaper"];
      # exec-once = ["swww-daemon"];
      # exec-once = ["wpaperd -d"];
    };
  };

  services.hyprpaper = {
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

  home.file."./.config/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  home.file."./.config/avatars" = {
    source = ./avatars;
    recursive = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 1;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = {
        color = "rgba(0, 0, 0, 1.0)";
      };
      input-field = [{
        size = "200, 50";
        position = "0, -80";
        dots_center = true;
        fade_on_empty = true;
        font_color = "rgba(202, 211, 245, 1.0)";
        inner_color = "rgba(91, 96, 120, 1.0)";
        outer_color = "rgba(24, 25, 38, 1.0)";
        outline_thickness = 5;
        placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
        shadow_passes = 2;
      }];
    };
  };

  programs.neovim = {
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
}
