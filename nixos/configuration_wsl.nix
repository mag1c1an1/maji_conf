let
  isWsl = builtins.getEnv "WSL" == "TRUE";
in
  {nixpkgs, ...}: {
    system.stateVersion = "25.05";
    wsl = {
      enable = isWsl;
      defaultUser = "mag1cian";
      extraBin = [
        {src = "${nixpkgs.coreutils}/bin/uname";}
        {src = "${nixpkgs.coreutils}/bin/mkdir";}
        {src = "${nixpkgs.coreutils}/bin/cp";}
        {src = "${nixpkgs.git}/bin/git";}
      ];
    };
  }
