{pkgs-unstable, ...}: {
  programs.wezterm = {
    package = pkgs-unstable.wezterm;
    enable = true;
  };
}
