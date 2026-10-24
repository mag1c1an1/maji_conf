{
  config,
  inputs,
  pkgs,
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
      nautilus
      ddcutil
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  hardware.i2c.enable = true;
  users.users.maji.extraGroups = ["i2c"];

  programs.clash-verge = {
    enable = true;
    group = "users";
    serviceMode = true;
    tunMode = true;
    autoStart = true;
  };

  # 开机就把 verge-mihomo 核心跑起来（SSH-only、没登录桌面时也有 127.0.0.1:7890 可用）。
  # 登录图形会话时 cosmic-session.target 启动 -> 本单元按 Conflicts 自动停止，
  # 把 7890 让给 clash-verge GUI（XDG autostart 拉起，经 clash-verge-service 自带核心），
  # GUI 表现与以往完全一致。
  users.users.maji.linger = true;

  systemd.user.services.verge-mihomo-boot = {
    description = "verge-mihomo core at boot (hands over to Clash Verge GUI on graphical login)";
    wantedBy = ["default.target"];
    unitConfig.Conflicts = "cosmic-session.target";
    # 这是用户级单元，对 greeter 等所有用户可见；限制只有 maji 的用户实例启动它，
    # 否则 greeter 实例会因读不了 /home/maji 下的配置而每 3 秒失败重启一次。
    unitConfig.ConditionUser = config.users.users.maji.name;
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %t/clash-verge-rev";
      ExecStart = "${config.programs.clash-verge.package}/bin/verge-mihomo -d ${config.users.users.maji.home}/.local/share/io.github.clash-verge-rev.clash-verge-rev -f ${config.users.users.maji.home}/.local/share/io.github.clash-verge-rev.clash-verge-rev/clash-verge.yaml";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # 桌面环境：COSMIC（2026-10-24 从 niri + DankMaterialShell 完全迁移过来）。
  # cosmic-greeter 同时接管 greetd（Xwayland 由 cosmic-comp 自己拉起，不用 xwayland-satellite）。
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.xserver.enable = false;
}
