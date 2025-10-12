{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
    };
  };
}
