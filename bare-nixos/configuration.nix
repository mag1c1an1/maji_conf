# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./docker.nix
    ./desktop.nix
    # ./cachix/devenv.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.loader.systemd-boot.windows = {
    "nvme1n1p1" = {
      title = "Windows 11";
      efiDeviceHandle = "FS0";
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  services.envfs.enable = true;
  hardware.nvidia.open = true; # see the note above
  hardware.nvidia.modesetting.enable = true;
  # 睡眠/唤醒必须保留显存内容。否则 resume 后 VRAM/GEM 里的 buffer 全是垃圾：
  # nvidia-drm 报 "Failed to apply atomic modeset (-11)"、Xid 13 Graphics Exception，
  # cosmic-comp 的 page flip 全部 EINVAL，屏幕黑着回不到桌面
  # （2026-10-24 13:39:08 suspend → 13:54:29 resume 实测，boot -1 日志）。
  # 驱动 595.71.05(open) + open=true → kernelSuspendNotifier 默认启用，走内核 suspend
  # notifier + NVreg_PreserveVideoMemoryAllocations=1，不需要 nvidia-suspend/resume 单元。
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  # 外置盘 aigo S7(USB 3535:1122, S/N YS20220271) 禁止 USB autosuspend：
  # power/control=on + autosuspend_delay_ms=-1，设备重枚举后也保持。
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="3535", ATTR{idProduct}=="1122", ATTR{serial}=="YS20220271", ATTR{power/control}="on", ATTR{power/autosuspend_delay_ms}="-1"
  '';

  # ── 内存保护：防止内存耗尽导致整机卡死 ────────────────────────────────
  # 2026-09-16 死机分析结论：
  #   - 系统完全没有 swap，匿名内存无法回收，内存到顶时内核进入 direct
  #     reclaim 全局停顿（journalctl -b -1 最后 20 秒只有零星日志，无 OOM 记录）
  #   - 同时期内核报 vmemmap alloc failure: order:9，NVIDIA 驱动报
  #     NV_ERR_NO_MEMORY（nvidia_uvm 注册 GPU 时分配失败）
  #   - 9/14、9/16 两次死机是同一签名；9/15 也出现过同类分配失败
  # 修复：zram（压缩内存当 swap，让匿名页可回收）+ earlyoom（提前杀最大户）
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # 压缩率约 2~3:1
    memoryPercent = 50; # 32GB 内存 → 最多 16GB zram（按需占用，不做预留）
  };

  # 可用内存或 swap 低于 10% 时，提前杀掉内存占用最大的进程，
  # 避免内核在 OOM 边界卡死（systemd-oomd 在无 swap 时能力受限）
  services.earlyoom.enable = true;

  # 保留 256MB 最低空闲内存，缓解碎片化时 order-9 连续页分配失败；
  # zram 场景下提高 swappiness，优先换出冷匿名页；
  # 打开完整 SysRq：下次卡死可先 Alt+SysRq+S 同步，再按 B 重启，减少数据风险
  boot.kernel.sysctl = {
    "vm.min_free_kbytes" = 262144;
    "vm.swappiness" = 100;
    "kernel.sysrq" = 1;
  };

  # 输入法:maji 自己写的 pinyinime(zwp_input_method_v2，见 home/desktop/default.nix)，
  # 不再用 fcitx5；COSMIC 自 1.0.0~beta.8 起实现 input-method-v2 + virtual-keyboard-v1。

  services.logind.settings.Login = {
    IdleAction = "ignore";
  };

  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;
  networking.hostName = "aorusx"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://127.0.0.1:10801";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.hack
      nerd-fonts._0xproto
      maple-mono.NF-CN-unhinted
    ];
    fontconfig = {
      defaultFonts = {
        # 无衬线体（绝大多数系统 UI、浏览器默认使用的字体类别）
        sansSerif = ["Inter" "Noto Sans CJK SC"];
        # 衬线体（常用于印刷、小说阅读）
        serif = ["Noto Serif" "Noto Serif CJK SC"];
        # 等宽字体（你的终端模拟器、代码编辑器默认调用的类别）
        monospace = ["Hack Nerd Fond" "Noto Sans Mono CJK SC"];
      };
      # 可选：开启一些渲染优化，让字体在 Linux 下更像 macOS 般圆润细腻
      hinting.enable = true;
      antialias = true;
      subpixel.lcdfilter = "default";
    };
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # 启用 Flakes 特性以及配套的船新 nix 命令行工具
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-users = [
    "root"
    "maji"
  ];
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
  ];

  systemd.services.nix-daemon.environment = {
    # 让 nix-daemon 的下载（binary cache / 固定输出 derivation）走 xray 代理
    # xray: 10801 = HTTP, 10800 = SOCKS5（与 git config 的 10801 一致）
    # no_proxy 用 nix-daemon 模块自带默认值（已含 127.0.0.1,localhost），不重复定义
    http_proxy = "http://127.0.0.1:10801";
    https_proxy = "http://127.0.0.1:10801";
    all_proxy = "socks5://127.0.0.1:10800";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
    git
    git-filter-repo
    fish
    neovim
    just
    pkg-config
    perf
    piper
    solaar
  ];

  programs.fish.enable = true;
  programs.git = {
    enable = true;
    config = {
      http.proxy = "http://127.0.0.1:10801";
      https.proxy = "http://127.0.0.1:10801";
    };
  };
  programs.nix-ld.enable = true;
  # 将默认编辑器设置为 vim
  environment.variables.EDITOR = "nvim";

  # 修复 Clash Verge (Tauri/WebKitGTK) webview 在 nvidia 上的 CPU 空转
  # （webview 常驻 ~50% CPU → 桌面持续渲染 → nvidia flip → ksoftirqd 风暴 → 风扇猛转）
  # 若无效可追加 WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  environment.sessionVariables = {
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
  };

  services.ratbagd.enable = true;
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.xray = {
    enable = true;
    settingsFile = "/home/maji/maji_conf/xray/client.json";
  };

  services.openssh = {
    enable = true;
    ports = [2222];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
      AllowUsers = ["maji"];
    };
  };

  services.frp.instances."aliyun" = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "101.132.60.231";
      serverPort = 7000;
      auth = {
        method = "token";
        token = "aorus-nixos";
      };
      proxies = [
        {
          name = "aorusx-ssh";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 2222;
          remotePort = 6000;
        }
        {
          name = "inference";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 8888;
          remotePort = 6001;
        }
      ];
    };
  };
  users.users.maji = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBUNrW/gxDVgH5M2YH5B6edo/0T4c3G85SmlZUMKwVGFCQaKvJz8uL0KjBjSAVNLzxDUV36DNhr82p31jcaDE4WdeglNKbTzcVfD1uNyNhD1yypiYNocFasSGaqOGQkxhcfq/NrUqeZjojWxXQDE9fjAeHRCodLcoE/DczIltc2ya7dIxWb9RUSzrSgQSOS0d2ZrQtruYfCSd00UKZlSogO3NKKgFCl+3ElwUirHK2icJ1yRtcEeKaW3W1vSVIn0Y+nR0KJmfAP1gEh8+VJkwQeuXcE6YAP2QLWCo6FKbEYevKMTNvrsWGx6BNQHVyTvZh67AjMZP4zQ3Tg77funu9"
    ];
  };
  services.kanata = {
    enable = false;

    keyboards.default = {
      config = ''
        (defsrc
          caps
        )

        (defalias
          ;; 点按 CapsLock -> F10
          ;; 长按 CapsLock -> CapsLock
          caps-ime (tap-hold 200 200 f10 caps)
        )

        (deflayer base
          @caps-ime
        )
      '';
    };
  };

  # timezone and local
  time.timeZone = "Asia/Shanghai";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    # 保持 en_US.UTF-8：若为 zh_CN，go-runewidth 会把 ─│└ 等字符按 2 列宽处理，
    # 与 Warp 的 1 列宽渲染不一致，导致 k9s 按 / 搜索时界面错位（#1241 同类问题）
    LC_CTYPE = "en_US.UTF-8";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  security.sudo.wheelNeedsPassword = false; # sudo组是否需要密码
  users.users.maji = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      google-chrome
      github-cli
    ];
  };
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
