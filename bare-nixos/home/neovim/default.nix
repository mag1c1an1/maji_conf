{config,pkgs,pkgs-unstable,...}:
{
  programs.neovim = {
    package = pkgs-unstable.neovim;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # extraConfig = ''
    #   inoremap JK <esc>
    #   set expandtab   
    #   set shiftwidth=2 
    #   set tabstop=2    
    #   set softtabstop=2 
    #   let s:uname_output = trim(system('uname -a'))
    #   if s:uname_output =~ 'orbstack'
    #     let g:clipboard = 'pbcopy'
    #   else
    #   endif
    # '';
    plugins = [
      pkgs-unstable.vimPlugins.LazyVim
    ];
  };
  home.file.".config/nvim" = {
    source = "${config.home.homeDirectory}/maji_conf/nvim";
    recursive = true;
  };
}
