{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    # userSettings = {
    #   node = {
    #     path = lib.getExe pkgs.nodejs;
    #     npm_path = lib.getExe' pkgs.nodejs "npm";
    #   };
    # };
  };
}
