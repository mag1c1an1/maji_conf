# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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

  # programs.firefox.enable = true;

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
      AllowUsers = ["mag1cian"];
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
