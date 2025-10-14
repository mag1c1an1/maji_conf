let
  isWsl = builtins.getEnv "WSL" == "TRUE";
in
  {
    pkgs,
    nixpkgs,
    lib,
    ...
  }: {
    imports = [
      ./common.nix
    ];
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    wsl = {
      enable = isWsl;
      defaultUser = "mag1cian";
      extraBin = [
        {src = "${pkgs.coreutils}/bin/uname";}
        {src = "${pkgs.coreutils}/bin/mkdir";}
        {src = "${pkgs.coreutils}/bin/cp";}
        {src = "${pkgs.git}/bin/git";}
      ];
    };
  }
