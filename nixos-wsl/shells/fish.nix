{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # ALIAS
      alias lg=lazygit

      # PATH
      fish_add_path $HOME/.cargo/bin
      fish_add_path $HOME/.local/bin

      # less
      set -gx LESSCHARSET utf-8

      # rustup
      set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
      set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"

      # uv
      set -gx UV_PYTHON_INSTALL_MIRROR "https://ghfast.top/https://github.com/indygreg/python-build-standalone/releases/download"
      set -gx UV_DEFAULT_INDEX https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

      function ra
       	set tmp (mktemp -t "yazi-cwd.XXXXXX")
       	yazi $argv --cwd-file="$tmp"
       	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        		builtin cd -- "$cwd"
       	end
       	rm -f -- "$tmp"
      end
    '';
  };
}
