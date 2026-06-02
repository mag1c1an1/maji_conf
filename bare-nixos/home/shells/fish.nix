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
      cc = "claude";
    };
    shellAliases = {
      cnpm = "npm --registry=https://registry.npmmirror.com  --cache=$HOME/.npm/.cache/cnpm  --disturl=https://npmmirror.com/mirrors/node  --userconfig=$HOME/.cnpmrc";
      nd = "nix develop -c fish";
      zed = "zeditor";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # PATH
      fish_add_path $HOME/.cargo/bin
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.npm-global/bin

      # less
      set -gx LESSCHARSET utf-8

      # EDITOR
      set -gx EDITOR nvim

      # rustup
      set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
      set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"

      # uv
      set -gx UV_PYTHON_INSTALL_MIRROR "https://ghfast.top/https://github.com/indygreg/python-build-standalone/releases/download"
      set -gx UV_DEFAULT_INDEX https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

      # proxy
      function proxy
        if string match -q "*orbstack*" (uname -a)
          set -gx HTTP_PROXY host.orb.internal:7890
          set -gx HTTPS_PROXY host.orb.internal:7890
        else
          set -gx HTTP_PROXY http://localhost:10801
          set -gx HTTPS_PROXY http://localhost:10801
          set -gx ALL_PROXY socks5h://localhost:10800
        end
      end

      function noproxy
        set -e HTTP_PROXY
        set -e HTTPS_PROXY
        set -e ALL_PROXY
      end

      proxy

      function ra
       	set tmp (mktemp -t "yazi-cwd.XXXXXX")
       	yazi $argv --cwd-file="$tmp"
       	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        		builtin cd -- "$cwd"
       	end
       	rm -f -- "$tmp"
      end

      function pythonEnv --description 'start a nix-shell with the given python packages' --argument pythonVersion
        if set -q argv[2]
            set argv $argv[2..-1]
        end

        for el in $argv
            set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
        end

        nix-shell -p $ppkgs
      end
    '';
  };
}
