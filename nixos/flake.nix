{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-wsl,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      # 这里的 my-nixos 替换成你的主机名称
      nixos = nixpkgs.lib.nixosSystem {
        modules = let
          isWsl = builtins.getEnv "WSL" == "TRUE";
        in [
          (
            if isWsl
            then ./configuration_wsl.nix
            else ./configuration_orb.nix
          )
          nixos-wsl.nixosModules.default
          # 将 home-manager 配置为 nixos 的一个 module
          # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mag1cian = import ./home;
              backupFileExtension = "backup";
              #extraSpecialArgs = inputs;
            };
          }
        ];
      };
    };
  };
}
