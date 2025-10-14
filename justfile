wsl:
   WSL=TRUE sudo -E nixos-rebuild switch --flake ./nixos#nixos --impure --show-trace
orb:
   WSL=FALSE sudo -E nixos-rebuild switch --flake ./nixos#nixos --impure --show-trace
