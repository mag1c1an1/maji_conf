{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = [
    pkgs.wechat
    pkgs.wpsoffice-cn
    # 飞书默认走 XWayland，XWayland 下拿不到 text-input-v3，pinyinime 无法输入。
    # 强制 ozone/Wayland + text-input-v3(7.66.10 实测可用，见 nixpkgs#318035 的历史崩溃已不复现)。
    (pkgs-unstable.feishu.override {
      commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    })
    pkgs.obsidian
    # 同飞书：默认走 XWayland 时拿不到 text-input-v3，pinyinime 无法输入。
    # 强制 ozone/Wayland + text-input-v3，让 VSCode 接 COSMIC 的 input-method-v2 输入法。
    (pkgs.vscode.override {
      commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    })
    pkgs.gthumb
    #pkgs.davinci-resolve
    pkgs.mpv
    # 原生拼音输入法(zwp_input_method_v2)，源码在本机 ~/repos/pinyinime
    inputs.pinyinime.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # COSMIC 的自动挂起由 cosmic-idle 负责（不是 logind，logind 侧 IdleAction=ignore）。
  # cosmic-config 每个键一个 RON 文件，值类型 Option<u32>，单位毫秒，None = 永不。
  # 默认 suspend_on_ac_time=1800000(30min) / suspend_on_battery_time=900000(15min)，
  # 空闲到点会直接执行 `systemctl suspend`，跑测试/编译时会把机器睡掉，故固定为永不。
  # screen_off_time 保持默认 15 分钟（黑屏 + loginctl lock-session）。
  xdg.configFile = {
    "cosmic/com.system76.CosmicIdle/v1/suspend_on_ac_time".text = "None";
    "cosmic/com.system76.CosmicIdle/v1/suspend_on_battery_time".text = "None";
  };

  # COSMIC 通过 XDG autostart 拉起输入法（cosmic-session 会启动 xdg-desktop-autostart.target）。
  xdg.configFile."autostart/pinyinime.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=pinyinime
    Exec=pinyinime
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';
}
