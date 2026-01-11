wsl:
   WSL=TRUE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

orb:
   WSL=FALSE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

link:
   ln $PWD/nix $HOME/.config/nix

upadte:
    cd nixos && nix flake update
