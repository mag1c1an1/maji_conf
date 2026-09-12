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
      swayidle
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

  programs.clash-verge = {
    enable = true;
    group = "users";
    serviceMode = true;
    tunMode = true;
    autoStart = true;
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

  # greeter 空闲熄屏：dms-greeter 生成 niri 配置时会 include 这个文件，
  # 用 swayidle 在空闲 10 分钟后关屏（DPMS Off），任意键鼠输入自动亮回登录界面。
  environment.etc."greetd/niri_overrides.kdl".text = ''
    spawn-at-startup "${pkgs.swayidle}/bin/swayidle" "-w" "timeout" "600" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors"
  '';
}
