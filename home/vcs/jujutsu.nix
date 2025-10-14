{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
       	name = "mag1cian";
        email = "mag1cian@icloud.com";
      };
      templates = {
        commit_trailers = "format_signed_off_by_trailer(self)";
      };
    };
  };
}