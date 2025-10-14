{ lib, pkgs,...}:
{
  imports = [
    ../nixos-common
  ]
  wsl = {
    enable = true;
     defaultUser = "mag1cian";
     extraBin = [
       {src = "${pkgs.coreutils}/bin/uname";}
       {src = "${pkgs.coreutils}/bin/mkdir";}
       {src = "${pkgs.coreutils}/bin/cp";}
       {src = "${pkgs.git}/bin/git";}
     ];
  };
}
