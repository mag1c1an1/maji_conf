wsl:
   WSL=TRUE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

orb:
   WSL=FALSE nixos-rebuild  switch --flake ./nixos#nixos --impure --show-trace --sudo

# 国内网络下 nix 下载的两个坑：
#   1) cache.nixos.org 的 IPv6 路径极慢（82 KB/s vs IPv4 1.9 MB/s）
#      → networking.enableIPv6 = false 已在 configuration.nix 里关掉
#   2) 评测 warp 那堆 git 依赖时会逐个回源探测 GitHub ref，代理不通就每次卡几十秒
#      → --option tarball-ttl 让它信任本地缓存的 ref
#   3) 直连 cache.nixos.org 慢时用交大镜像
nixopts := "--option tarball-ttl 31536000 --option substituters 'https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org'"

bare:
   nixos-rebuild  switch --flake ./bare-nixos#AORUSX --impure --show-trace --sudo -L {{nixopts}}

link:
   ln -s $PWD/fish/themes $HOME/.config/fish/themes
   ln -s $PWD/bare-nixos/home/shells/starship.toml $HOME/.config/starship.toml
   ln -s $PWD/wezterm/.wezterm.lua $HOME/.config/.wezterm.lua
   # ln $PWD/nix $HOME/.config/nix

update:
   cd bare-nixos && nix flake update nixpkgs-zed
   cd bare-nixos && nix flake update nixpkgs-warp
   # cd nixos && nix flake update

init:
  echo "trusted-users = root $USER" | sudo tee --append /etc/nix/nix.conf

exec:
  sudo HTTP_PROXY=http://localhost:10801 HTTPS_PROXY=http://localhost:10801 ALL_PROXY=http://localhost:10801 WSL=TRUE nixos-rebuild switch --flake ./nixos#nixos --impure --show-trace
