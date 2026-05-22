{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
      pavucontrol
      wl-clipboard
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  programs.clash-verge = {
    enable = true;
    package = pkgs-unstable.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
    autoStart = true;
  };
  # Use niri as the Wayland compositor instead of GNOME.
  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  programs.niri = {
    enable = true;
    outputs = {
      "DP-1" = {
        scale = 1.5;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 170.0;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-2" = {
        scale = 1.5;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 170.0;
        };
        position = {
          x = 2560;
          y = 0;
        };
      };
      "HDMI-A-1" = {
        scale = 1;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 59.950;
        };
        position = {
          x = 320;
          y = 1440;
        };
      };
    };
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };
}
