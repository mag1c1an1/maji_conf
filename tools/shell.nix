# shell.nix
let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = with pkgs; [
    python313
    python313Packages.toml
  ];
}
