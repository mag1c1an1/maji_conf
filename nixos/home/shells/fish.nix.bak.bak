
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "lsd";
      lt = "lsd --tree";
      l = "lsd -al";
      ll = "lsd -l";
      lg = "lazygit";
      lj = "lazyjj";
      zj = "zellij";
      jt = "just";
    };
    shellAliases = {
      cnpm = "npm --registry=https://registry.npmmirror.com  --cache=$HOME/.npm/.cache/cnpm  --disturl=https://npmmirror.com/mirrors/node  --userconfig=$HOME/.cnpmrc";
    };
    interactiveShellInit = ''
      if status is-interactive
          and not set -q SSH_ORIGINAL_COMMAND
          and test -t 0
          and command -q nu

          exec nu
      end
    '';
  };
}
