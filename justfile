wsl:
   sudo -E nixos-rebuild switch --flake ./nixos-wsl#nixos --impure --show-trace
orb:
   sudo -E nixos-rebuild switch --flake ./nixos-orb#nixos --impure --show-trace
