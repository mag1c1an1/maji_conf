{pkgs, pkgs-unstable,...}: {
  imports = [
    ./shells
    ./vcs
    ./neovim
    ./zed
    ./utils
  ];
  home.username = "mag1cian";
  home.homeDirectory = "/home/mag1cian";
  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = [
    # archives
    pkgs.unzip
    # utils
    pkgs.lsd
    pkgs.zoxide
    pkgs.ripgrep # recursively searches directories for a regex pattern
    pkgs.fd
    pkgs.yazi
    pkgs.zellij
    pkgs.just
    pkgs.tokei
    pkgs.dust
    # vcs
    pkgs.git
    pkgs.lazygit
    pkgs.jujutsu
    pkgs.lazyjj
    pkgs.gh
    # editor
    pkgs.zed-editor
    pkgs-unstable.neovim
    # rust
    pkgs.rustup
    pkgs.protobuf

    pkgs.minio-client

    pkgs.lefthook
    pkgs.taplo

    # go
    pkgs.go
    # python
    pkgs.uv
    # cpp
    pkgs.clang
    pkgs.clang-tools
    pkgs-unstable.xmake
    pkgs.cmake
    pkgs.gnumake
    pkgs.ninja
    # parser
    pkgs.flex
    pkgs.bison
    # nix related
    pkgs.nixd
    pkgs.alejandra
    # debug
    pkgs.lldb
    # node
    pkgs.nodejs_24
    pkgs.pnpm
    # networking tools
    # productivity
    pkgs.btop # replacement of htop/nmon
    # system call monitoring
    pkgs.lsof # list open files

    pkgs.direnv
    pkgs.openssl

    pkgs.tokio-console

    pkgs.metals # scala

    # java
    pkgs.temurin-jre-bin-11
    pkgs.gradle
    pkgs.jdt-language-server # java
    # python
    pkgs.python313
  ];
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
  programs.java = {
    enable = true;
    package = pkgs.temurin-jre-bin-11;
  };
  home.file = {
	  ".cargo/config.toml" = {
		text = ''
[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
		'';
	  };
  };
}
