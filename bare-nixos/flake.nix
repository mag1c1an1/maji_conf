{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-26.05&shallow=1";
    # nixpkgs-unstable.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Zed 使用独立的 nixpkgs，这样可以只更新 Zed 而不影响其他 unstable 软件。
    nixpkgs-zed.url = "github:NixOS/nixpkgs/nixos-unstable";

    cc-switch-cli = {
      url = "github:saladday/cc-switch-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 本机仓库里的输入法(zwp_input_method_v2)，不经过 GitHub：
    # 固定到 jj 工作区快照，包含设置界面与 CapsLock 修复；不复制 .git/.jj 历史。
    pinyinime = {
      url = "git+file:///home/maji/repos/pinyinime?rev=4f4e213fbb098a74436bf36a33a8ae2be4c05221";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WeType 运行资源（词典/模型）。路径必须是真实文件目录；软链接在构建沙箱里不可用。
    wetype-data = {
      url = "path:/home/maji/.local/share/wetype";
      flake = false;
    };

    # 本地自编译的 Warp（upstream + IME 候选窗修复补丁）：
    # 只拷 tracked 文件，不拷 .git。
    warp-ime = {
      url = "git+file:///home/maji/repos/warp-ime";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Vicinae 官方建议不要 follows nixpkgs，
    # 否则它自己的 Cachix cache 可能 miss。
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-zed,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      AORUSX = let
        hostPlatform = "x86_64-linux";

        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = hostPlatform;
            config.allowUnfree = true;
          };
          pkgs-zed = import nixpkgs-zed {
            system = hostPlatform;
            config.allowUnfree = true;
          };

          inherit inputs;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }

            ./configuration.nix

            # home-manager 作为 NixOS module
            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.maji = {
                  imports = [
                    ./home
                  ];
                };

                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };
    };
  };
}
