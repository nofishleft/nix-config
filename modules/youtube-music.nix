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
        type = with lib.types; listOf lines;
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
    home.file.".config/Youtube Music/config.json" = {
      text = builtins.toJSON (
        {
          options = config.programs.youtube-music.settings // {
          themes = config.programs.youtube-music.themes;
        };
          plugins = config.programs.youtube-music.plugins;
        } // config.programs.youtube-music.extraConfig
      );
    };
  };
}
