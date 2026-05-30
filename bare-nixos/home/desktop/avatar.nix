{...}: let
  username = "maji";
  avatar = "/home/maji/Pictures/jp.png";
in {
  services.accounts-daemon.enable = true;

  systemd.tmpfiles.rules = [
    # 复制头像到 AccountsService 头像目录
    "C /var/lib/AccountsService/icons/${username} 0644 root root - ${avatar}"

    # 写入用户 AccountsService 配置
    "f /var/lib/AccountsService/users/${username} 0644 root root -"
  ];

  system.activationScripts.setUserAvatar.text = ''
        mkdir -p /var/lib/AccountsService/users /var/lib/AccountsService/icons
        cat > /var/lib/AccountsService/users/${username} <<EOF
    [User]
    Icon=/var/lib/AccountsService/icons/${username}
    EOF
  '';
}
