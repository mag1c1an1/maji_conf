{ config, pkgs, lib, ... }:

{
  imports = [
   ];
  home.username = "mag1cian";
  home.homeDirectory = "/home/mag1cian";
  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # archives
    unzip
    # utils
    zoxide
    ripgrep # recursively searches directories for a regex pattern
    fd
    yazi
    zellij
    just
    # vcs
    git
    lazygit
    jujutsu
    lazyjj
    gh
    # system
    nix-ld
    # editor
    zed-editor
    # rust
    rustup
    # go
    go
    # python
    uv
    # cpp
    clang
    xmake
    # nix related
    nixd
    alejandra
    # debug
    lldb
    # node
    nodejs_24
    # networking tools
    # productivity
    btop  # replacement of htop/nmon
    # system call monitoring
    lsof # list open files
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "mag1c1an1";
    userEmail = "mag1cian@icloud.com";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  # 启用 starship，这是一个漂亮的 shell 提示符
  # TODO add conf
  programs.starship = {
    enable = true;
    settings = {
    };
  };


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

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
       	name = "mag1cian";
        email = "mag1cian@icloud.com";
      };
      templates = {
        commit_trailers = "format_signed_off_by_trailer(self)";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.commit.signOff = true;
    };
  };

  programs.neovim = {
  enable = true;
  extraConfig = ''
    inoremap jk <esc>
  '';
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      node = {
                    path = lib.getExe pkgs.nodejs;
                    npm_path = lib.getExe' pkgs.nodejs "npm";
                };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration= true;
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
