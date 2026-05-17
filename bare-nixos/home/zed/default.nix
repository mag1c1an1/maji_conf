{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  # home.file.".config/zed/settings.json" = ../../../zed/settings.json;
  # home.file.".config/zed/keymap.json" = ../../../zed/keymap.json;
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    package = pkgs-unstable.zed-editor;
    # userSettings = {
    #   node = {
    #     path = lib.getExe pkgs.nodejs;
    #     npm_path = lib.getExe' pkgs.nodejs "npm";
    #   };
    # };
  };
}
