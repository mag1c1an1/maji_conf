{config, lib, pkgs,...}:
{
  imports = [
    <nixos-wsl/modules>
  ];
  nix.settings.substituters = lib.mkForce ["https://mirror.sjtu.edu.cn/nix-channels/store"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    fish
  ];
}
