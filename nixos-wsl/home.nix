{  pkgs, lib, ... }:

{
  imports = [
    ./shells
    ./vcs
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




  programs.neovim = {
  enable = true;
  defaultEditor = true;
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
