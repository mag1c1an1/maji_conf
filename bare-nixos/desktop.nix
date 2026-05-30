{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
      pavucontrol
      wl-clipboard
      xwayland-satellite
      nautilus
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  environment.sessionVariables = {
    # XMODIFIERS = "@im=fcitx";
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    # SDL_IM_MODULE = "fcitx";
    # GLFW_IM_MODULE = "ibus";
  };
  programs.clash-verge = {
    enable = true;
    package = pkgs-unstable.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
    autoStart = true;
  };

  systemd.services.clash-verge.serviceConfig = {
    Group = lib.mkForce "wheel";
    RuntimeDirectoryMode = lib.mkForce "0770";
  };
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
