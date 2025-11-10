{
  programs.neovim = {
  enable = true;
  defaultEditor = true;
  extraConfig = ''
    inoremap JJ <esc>
  '';
  };
}
