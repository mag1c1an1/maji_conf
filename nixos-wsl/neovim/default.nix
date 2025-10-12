{
  programs.neovim = {
  enable = true;
  defaultEditor = true;
  extraConfig = ''
    inoremap jk <esc>
  '';
  };
}
