{
  programs.nushell = {
    enable = true;
    configFile.source = ../../../nushell/config.nu;
    envFile.source = ../../../nushell/env.nu;
    shellAliases = {
      l = "ls -al";
      ll = "ls -l";
      lg = "lazygit";
      zj = "zellij";
      cc = "claude";
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
  };
}
