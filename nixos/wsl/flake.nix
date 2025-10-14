{
  description = "ADD WSL CONF";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {
    nixpkgs,
    nixos-wsl,
    ...
  }: {
    nixosConfigurations = {
      # 这里的 my-nixos 替换成你的主机名称
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl = {
              enable = true;
              defaultUser = "mag1cian";
              extraBin = [
                {src = "${nixpkgs.coreutils}/bin/uname";}
                {src = "${nixpkgs.coreutils}/bin/mkdir";}
                {src = "${nixpkgs.coreutils}/bin/cp";}
                {src = "${nixpkgs.git}/bin/git";}
              ];
            };
          }
        ];
      };
    };
  };
}
