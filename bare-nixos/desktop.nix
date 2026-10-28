{
  config,
  inputs,
  lib,
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

  # 登录界面（greeter 会话）不会自动熄屏：cosmic-greeter-start 只 exec cosmic-comp，
  # cosmic-idle 只由 cosmic-session 在用户会话里拉起，greeter 会话里没人消费 idle 事件，
  # 所以永远不 DPMS off（services.logind.settings.Login.IdleAction = "ignore" 只管
  # 系统级 idle 动作，跟熄屏无关）。这里在 greeter 会话里额外拉起 cosmic-idle，
  # 用 until 循环重试，等 compositor 的 wayland socket 就绪。
  services.greetd.settings.default_session.command = let
    greeterWithIdle = pkgs.writeShellScript "cosmic-greeter-with-idle" ''
      rm -rf /run/cosmic-greeter/cosmic/com.system76.CosmicSettingsDaemon/v1/* 2>/dev/null
      ( until ${lib.getExe pkgs.cosmic-idle}; do sleep 1; done ) >/dev/null 2>&1 &
      exec ${lib.getExe' config.services.displayManager.cosmic-greeter.package "cosmic-greeter-start"}
    '';
  in
    lib.mkForce (lib.concatStringsSep " " [
      (lib.getExe' pkgs.coreutils "env")
      "XCURSOR_THEME=\"\${XCURSOR_THEME:-Pop}\""
      (toString greeterWithIdle)
    ]);

  services.xserver.enable = false;
}
