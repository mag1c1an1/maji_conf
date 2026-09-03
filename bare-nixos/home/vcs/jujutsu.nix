{
  pkgs-unstable,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    # 与 home.packages 中移除的 jujutsu 对应,固定用 unstable 版本
    package = pkgs-unstable.jujutsu;
    settings = {
      user = {
       	name = "mag1cian";
        email = "mag1cian@icloud.com";
      };
      templates = {
        commit_trailers = ''
        format_signed_off_by_trailer(self)
        ++ if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'';
      };
    };
  };
}
