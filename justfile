wsl:
   WSL=TRUE nixos-rebuild --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" switch --flake ./nixos#nixos --impure --show-trace --sudo

orb:
   WSL=FALSE nixos-rebuild --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" switch --flake ./nixos#nixos --impure --show-trace --sudo

link:
   ln $PWD/nix $HOME/.config/nix

upadte:
    cd nixos && nix flake update
