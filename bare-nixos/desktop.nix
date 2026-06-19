{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    ./avatar.nix
    ./steam.nix
  ];
  environment.systemPackages = with pkgs;
    [
      # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
      pavucontrol
      wl-clipboard
      xwayland-satellite
      nautilus
      ddcutil
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    hardware.i2c.enable = true;
    users.users.maji.extraGroups = ["i2c"];
  environment.sessionVariables = {
    # XMODIFIERS = "@im=fcitx";
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    # SDL_IM_MODULE = "fcitx";
    # GLFW_IM_MODULE = "ibus";
  };

  # systemd.services.clash-verge.serviceConfig = {
  #   Group = lib.mkForce "wheel";
  #   RuntimeDirectoryMode = lib.mkForce "0770";
  # };
  #
  # Use niri as the Wayland compositor instead of GNOME.
  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  programs.xwayland.enable = true;

  programs.niri = {
    enable = true;
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/maji";
  };
}
