{pkgs,pkgs-unstable,lib,config, ...}:

{
    nix = {
        settings = {
            substituters = ["https://mirror.tuna.tsinghua.edu.cn/nix-channels/store"];
            experimental-features = [ "nix-command" "flakes" ];
        };
    };
    environment.systemPackages = [
        pkgs.git
        pkgs.wget
        pkgs.fish
        pkgs.vim
        pkgs.neovim
        pkgs.pkg-config
        pkgs.openssl
        # ((pkgs.vim_configurable.override {  }).customize{
        #   name = "vim";
        # vimrcConfig.customRC = ''
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
        #   }
        # )
        config.boot.kernelPackages.perf
    ];
    programs.fish.enable = true;
    programs.git = {
    	enable = true;
	lfs.enable = true;
    };
    programs.nix-ld.enable = true;
    users = {
        defaultUserShell = pkgs.fish;
        users.mag1cian.shell = pkgs.fish;
        users.mag1cian.extraGroups = ["docker"];
    };
    i18n.defaultLocale = "en_US.UTF-8";

    virtualisation.docker = {
      enable = true;
      # Customize Docker daemon settings using the daemon.settings option
      daemon.settings = {
        registry-mirrors = [ "https://mirror.gcr.io" ];
      };
      # Use the rootless mode - run Docker daemon as non-root user
      rootless = {
          enable = true; setSocketVariable = true;
      };
    };

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
}
