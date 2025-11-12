{
  programs.neovim = {
  enable = true;
  defaultEditor = true;
  extraConfig = ''
    inoremap JJ <esc>
    set expandtab   
    set shiftwidth=2 
    set tabstop=2    
    set softtabstop=2 
  '';
  };
}
