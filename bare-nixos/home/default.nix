{
  inputs,
  pkgs,
  pkgs-unstable,
  pkgs-warp,
  ...
}: {
  imports = [
    ./shells
    ./vcs
    ./neovim
    ./zed
    ./utils
    ./fcitx5
    ./desktop
    ./ghostty.nix
  ];
  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home = {
    username = "maji";
    homeDirectory = "/home/maji";
    packages =
      (with pkgs; [
        # archives
        unzip
        # utils
        lsd
        zoxide
        ripgrep # recursively searches directories for a regex pattern
        fd
        yazi
        zellij
        just
        tokei
        dust
        jq
        lazygit
        # github
        gh
        # rust
        rustup
        protobuf_25
        # git hook
        lefthook
        taplo

        # go
        go
        # python
        uv
        # cpp
        clang
        clang-tools
        cmake
        gnumake
        ninja
        # parser
        flex
        bison
        # nix related
        nixd
        alejandra
        # debug
        lldb
        # node
        nodejs_24
        pnpm
        # networking tools
        # productivity
        btop # replacement of htop/nmon
        # system call monitoring
        lsof # list open files

        direnv
        openssl

        # parquet
        parquet-tools

        # java
        gradle
        maven
        jdt-language-server # java
        # python
        python313
        # pg
        postgresql
        # lsp
        ty
        ruff
        tinymist
        #sandbox
        bubblewrap
        # idea
        jetbrains.idea
        jetbrains.gateway
        nvtopPackages.nvidia
        # 
        minio-client
        tealdeer
      ])
      ++ (
        with pkgs-unstable; [
          xmake
          neovim
          devenv
          jujutsu
        ]
      )
      ++ [
        inputs.cc-switch-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs-warp.warp-terminal
      ];
    stateVersion = "25.05";
    file = {
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
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.npm-global/bin"
    ];
    sessionVariables = {
      RUST_DIST_SERVER = "https://rsproxy.cn";
      RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
      UV_PATHON_INSTALL_MIRROR = "https://ghfast.top/https://github.com/indygreg/python-build-standalone/releases/download";
      UV_DEFAULT_INDEX = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
    };
  };
  programs = {
    java = {
      enable = true;
      package = pkgs.temurin-bin-17;
    };
  };
  xdg.enable = true;
}
