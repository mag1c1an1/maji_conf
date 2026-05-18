# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # inputs.dms.nixosMoudles.dank-material-shell
    inputs.dms.nixosModules.greeter
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
  hardware.nvidia.open = true; # see the note above
  hardware.nvidia.modesetting.enable = true;

  # 选择输入法类型为 fcitx5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [pkgs.rime-ice];
        })
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-chinese-addons # 拼音、五笔等
      ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          # "Behavior" = {
          # 关键设置：关闭程序内预编辑，强制使用 Fcitx5 浮窗(能解决 neovide 中无法预编辑的问题)
          # "PreeditEnabledByDefault" = "False";
          # };
          "Hotkey/TriggerKeys" = {"0" = "F10";};
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
      };
    };
  };

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
  # networking.hostName = "AUROSX"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:10801";
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
    ];
  };

  # Use niri as the Wayland compositor instead of GNOME.
  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  programs.niri = {
    enable = true;
  };

  # programs.dms-shell = {
  #   enable = true;
  #   systemd = {
  #     enable = true;
  #     restartIfChanged = true;
  #   };
  #   enableSystemMonitoring = true; # System monitoring widgets (dgop)
  #   enableVPN = false; # VPN management widget
  #   enableDynamicTheming = true; # Wallpaper-based theming (matugen)
  #   enableAudioWavelength = true; # Audio visualizer (cava)
  #   enableCalendarEvents = true; # Calendar integration (khal)
  #   enableClipboardPaste = true;
  # };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # services.displayManager.defaultSession = "niri";
  # services.greetd = {
  #   enable = true;
  #   useTextGreeter = true;
  #   settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd ${config.programs.niri.package}/bin/niri-session";
  # };

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
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
  ];

  # programs.firefox.enable = true;
  # programs.dms-shell = {
  #   enable = true;
  #   enableSystemMonitoring = true;
  #   dgop.package = inputs.dgop.packages.$[pkgs.stdenv.hostPlatform.system].default;
  # }

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs;
    [
      # Flakes 通过 git 命令拉取其依赖项，所以必须先安装好 git
      git
      fish
      neovim
      just
      pkg-config
      pavucontrol
      wl-clipboard
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.nix-ld.enable = true;
  # 将默认编辑器设置为 vim
  environment.variables.EDITOR = "nvim";

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

  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "101.132.60.231";
      serverPort = 7000;
      auth = {
        method = "token";
        token = "wsl-nixos";
      };
      proxies = [
        {
          name = "nixos-ssh";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 2222;
          remotePort = 6000;
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
    enable = true;

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
    LC_CTYPE = "zh_CN.UTF-8";
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
