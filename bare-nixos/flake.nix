{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.11 分支
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    #codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    #claude-code.url = "github:sadjow/claude-code-nix";
    #cc-switch-cli.url = "github:saladday/cc-switch-cli";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url  = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      AORUSX = let
        # Define specialArgs in a `let` block so it's in scope for the `in` block below
	hostPlatform = "x86_64-linux";
        specialArgs = {
          # 注意每次 import 都会生成一个新的 nixpkgs 实例
          # 这里我们直接在 flake.nix 中创建实例， 再传递到其他子 modules 中使用
          # 这样能有效重用 nixpkgs 实例，避免 nixpkgs 实例泛滥。
          pkgs-unstable = import nixpkgs-unstable {
	    inherit hostPlatform;
            # 为了拉取 chrome 等软件包，
            # 这里我们需要允许安装非自由软件
            config.allowUnfree = true;
          };
          inherit inputs;
        };
      in nixpkgs.lib.nixosSystem {
        # Pass specialArgs to all NixOS modules, including home-manager's module.
        # This is the standard way to make these arguments available everywhere.
        inherit specialArgs;

        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }
	  ./configuration.nix
          # 将 home-manager 配置为 nixos 的一个 module
          # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.maji = import ./home;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              # from `nixosSystem` are automatically passed to your home-manager configuration.
              # You can now access `pkgs-unstable` directly in your `./home` files.
            };
          }
        ];
      };
    };
  };
}
