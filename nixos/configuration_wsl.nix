let
  isWsl = builtins.getEnv "WSL" == "TRUE";
in
  {
    pkgs,
    nixpkgs,
    lib,
    ...
  }: {
    imports = [
      ./common.nix
    ];
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    services.openssh = {
      enable = true;
      ports = [2222];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
        AllowUsers = [ "mag1cian" ];
      };
    };
    services.tailscale = {enable=true;};
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
    services.xray = {
      enable = true;
      settingsFile = "/home/mag1cian/maji_conf/xray/client.json";
    };
    users.users.mag1cian = {
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBUNrW/gxDVgH5M2YH5B6edo/0T4c3G85SmlZUMKwVGFCQaKvJz8uL0KjBjSAVNLzxDUV36DNhr82p31jcaDE4WdeglNKbTzcVfD1uNyNhD1yypiYNocFasSGaqOGQkxhcfq/NrUqeZjojWxXQDE9fjAeHRCodLcoE/DczIltc2ya7dIxWb9RUSzrSgQSOS0d2ZrQtruYfCSd00UKZlSogO3NKKgFCl+3ElwUirHK2icJ1yRtcEeKaW3W1vSVIn0Y+nR0KJmfAP1gEh8+VJkwQeuXcE6YAP2QLWCo6FKbEYevKMTNvrsWGx6BNQHVyTvZh67AjMZP4zQ3Tg77funu9"
    ];
    };
    wsl = {
      enable = isWsl;
      defaultUser = "mag1cian";
      extraBin = [
        {src = "${pkgs.coreutils}/bin/uname";}
        {src = "${pkgs.coreutils}/bin/mkdir";}
        {src = "${pkgs.coreutils}/bin/cp";}
        {src = "${pkgs.git}/bin/git";}
      ];
    };
  }
