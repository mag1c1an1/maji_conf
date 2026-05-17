wsl:
   WSL=TRUE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

orb:
   WSL=FALSE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

bare:
   nixos-rebuild  switch --flake ./bare-nixos#AORUSX --impure --show-trace --sudo

link:
   ln $PWD/nix $HOME/.config/nix

upadte:
   cd nixos && nix flake update

init:
  echo "trusted-users = root $USER" | sudo tee --append /etc/nix/nix.conf

exec:
  sudo HTTP_PROXY=http://localhost:10801 HTTPS_PROXY=http://localhost:10801 ALL_PROXY=http://localhost:10801 WSL=TRUE nixos-rebuild switch --flake ./nixos#nixos --impure --show-trace
