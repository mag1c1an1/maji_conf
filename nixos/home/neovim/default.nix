{pkgs,pkgs-unstable,...}:
{
  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    # extraConfig = ''
    #   inoremap JJ <esc>
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
    source = "/home/mag1cian/maji_conf/nvim";
    recursive = true;
  };
}
