{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.11 分支
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-unstable.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";

    cc-switch-cli = {
      url = "github:saladday/cc-switch-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    # Vicinae 官方建议不要 follows nixpkgs，
    # 否则它自己的 Cachix cache 可能 miss。
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    vicinae,
    ...
  }: {
    nixosConfigurations = {
      AORUSX = let
        hostPlatform = "x86_64-linux";

        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            inherit hostPlatform;
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

              # Vicinae Cachix，避免本地编译
              nix.settings = {
                extra-substituters = [
                  "https://vicinae.cachix.org"
                ];
                extra-trusted-public-keys = [
                  "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
                ];
              };
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
