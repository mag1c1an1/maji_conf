{pkgs-unstable, ...}: {
  programs.ghostty = {
    package = pkgs-unstable.ghostty;
    enable = true;
  };
}
