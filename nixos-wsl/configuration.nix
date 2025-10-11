{config, lib, pkgs,...}:

{
  wsl.defaultUser = "mag1cian";
  wsl.extraBin = [
    {src = "${pkgs.coreutils}/bin/uname";}
    {src = "${pkgs.coreutils}/bin/mkdir";}
    {src = "${pkgs.coreutils}/bin/cp";}
  ];

  nix.settings.substituters = lib.mkForce ["https://mirror.sjtu.edu.cn/nix-channels/store"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    fish
  ];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users.mag1cian.shell = pkgs.fish;
}
