{ inputs, pkgs, lib, config, ... }:

{
  options = {
    programs.youtube-music = {
      enable = lib.mkEnableOption "youtube-music";
      settings = {
        tray = lib.mkEnableOption "tray";
        autoUpdates = lib.mkEnableOption "autoUpdates";
        disableHardwareAcceleration = lib.mkEnableOption "disableHardwareAcceleration";
      };
      themes = lib.mkOption {
        description = "";
        type = with lib.types; listOf str;
        default = [];
      };
      plugins = lib.mkOption {
        description = "";
        type = lib.types.attrs;
        default = {};
      };
      extraConfig = lib.mkOption {
        description = "";
        type = lib.types.attrs;
        default = {};
      };
      package = lib.mkPackageOption pkgs "youtube-music" { };
    };
  };

  config = lib.mkIf config.programs.youtube-music.enable {
    home.packages = lib.concatLists [
      (lib.optional (config.programs.youtube-music.package != null) config.programs.youtube-music.package)
    ];
    /*home.file.".config/YouTube Music/config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/phush/.config/YouTube Music/hm-config.json";
    };*/
    hm-impermanent = "cp '/home/phush/.config/YouTube Music/hm-config.json' '/home/phush/.config/YouTube Music/config.json'";
    home.file.".config/YouTube Music/hm-config.json" = {
      text = builtins.toJSON (
        {
          options = config.programs.youtube-music.settings // {
            themes = [] ++ (lib.optionals (builtins.elem "rose-pine" config.programs.youtube-music.themes) [
              "/home/phush/.config/YouTube Music/themes/rose-pine.css"
            ]);
          };
          plugins = config.programs.youtube-music.plugins;
        } // config.programs.youtube-music.extraConfig
      );
    };
    home.file.".config/YouTube Music/themes/rose-pine.css" = lib.mkIf (builtins.elem "rose-pine" config.programs.youtube-music.themes) {
      source = ./../themes/youtube-music/rose-pine.css;
    }; 
  };
}
