{...}: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # 数据/镜像存到外置盘（/home/maji/mobile 是独立 ext4 分区）
      data-root = "/home/maji/mobile/docker";
    };
  };
  users.users.maji.extraGroups = ["docker"];
  # 确保分区挂载后再启动 docker（分区在 fstab 中带 nofail，未挂载时 docker 会拒绝启动而不是写进根分区）
  systemd.services.docker.unitConfig.RequiresMountsFor = ["/home/maji/mobile/docker"];
  systemd.services.docker.environment = {
    HTTP_PROXY = "http://127.0.0.1:7890";
    HTTPS_PROXY = "http://127.0.0.1:7890";
    NO_PROXY = "localhost,127.0.0.1,::1";
  };
}
