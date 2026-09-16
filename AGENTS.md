# AGENTS.md — maji_conf

个人配置仓库。给 AI agent / 未来自己的操作指南，重点是**如何重建本机 NixOS 系统**。

## 仓库概览

| 目录 | 用途 |
|---|---|
| `bare-nixos/` | **当前主机 `aorusx` 的 NixOS flake（真正会被 rebuild 的配置）** |
| `nixos/` | WSL / orb 环境用的另一套 flake（`nixos#nixos`），与本机无关 |
| `nvim/` `fish/` `ghostty/` `zellij/` `wezterm/` `zed/` `clash/` `xray/` `avatar/` `nushell/` `rime/` `tools/` | 应用运行时配置。部分被 Nix 以绝对路径直接引用（如 `bare-nixos/home/neovim/default.nix` → `${config.home.homeDirectory}/maji_conf/nvim`），改这些文件通常**不需要** rebuild，但注意路径必须存在 |
| `justfile` | 常用入口，见下 |

系统本体：NixOS 26.05、主机名 `aorusx`、flake 输出 `AORUSX`、用户 `maji`；home-manager 集成在同一个 flake 里（`bare-nixos/flake.nix`）。

## 重建本机系统（最重要）

在仓库根目录：

```bash
cd /home/maji/maji_conf
just bare
```

`justfile` 里等价于：

```bash
sudo nixos-rebuild switch --flake ./bare-nixos#AORUSX --impure --show-trace -L
```

要点：

- **必须加 `--impure`**：`bare-nixos/home/neovim/default.nix` 引用了绝对路径 `/home/maji/maji_conf/nvim`，纯评估模式会报
  `access to absolute path ... is forbidden in pure evaluation mode`。
- `sudo` 免密（`configuration.nix` 里 `security.sudo.wheelNeedsPassword = false`），可直接执行。
- 在仓库根执行；不在根目录时用绝对路径：`--flake /home/maji/maji_conf/bare-nixos#AORUSX`。

### 更稳妥的流程（建议）

```bash
# 1) 只构建，验证 eval/编译是否通过（不激活、不进 boot menu）
nixos-rebuild build --flake ./bare-nixos#AORUSX --impure

# 2) 构建通过后再切换
just bare

# 3) 临时激活（重启后回到原配置），用于试验
sudo nixos-rebuild test --flake ./bare-nixos#AORUSX --impure

# 4) 出问题回滚
sudo nixos-rebuild switch --rollback
nixos-rebuild list-generations
```

### 更新依赖

```bash
just update                                  # 只更新 nixpkgs-zed
cd bare-nixos && nix flake update <input>    # 如 nixpkgs / home-manager / vicinae ...
alejandra bare-nixos/                        # 格式化 nix 文件
```

## 注意事项 / 常见坑

1. **新文件必须先 `git add`**：flake 在 git 仓库中评估时**只看得见已 tracked 的文件**。
   新增 `bare-nixos/home/**/xxx.nix` 后如果没 `git add`，rebuild 会报找不到文件/属性。
   修改已跟踪文件只会提示 `Git tree ... is dirty`（正常现象，不影响构建）。
2. `nixos-rebuild build` 会在仓库里生成 `result` 软链接（未跟踪）；用完删掉，避免误提交。仓库目前没有 `.gitignore`。
3. `bare-nixos/hardware-configuration.nix` 是 `nixos-generate-config` 生成的，非必要不要手改。
4. `system.stateVersion = "25.11"` 不要动。
5. 下载走代理：nix-daemon 环境变量指向 `127.0.0.1:10801`（xray）；flake 里已配 USTC / NJU 镜像。
   若 rebuild 卡在 fetching，先确认 xray / clash-verge 在运行。
6. home-manager 只影响 `maji`；用户级的包和配置都在 `bare-nixos/home/` 下。
7. 新建 home 模块要挂到 `bare-nixos/home/default.nix` 的 `imports` 列表里。

## 配置布局（改哪里）

```
bare-nixos/configuration.nix           # 系统入口（imports: hardware / docker.nix / desktop.nix / ...）
bare-nixos/desktop.nix                 # 桌面环境（niri、dms、clash-verge、greeter；imports: avatar.nix / steam.nix）
bare-nixos/docker.nix                  # Docker
bare-nixos/steam.nix                   # Steam（由 desktop.nix 引入）
bare-nixos/home/default.nix            # home-manager 用户入口（imports: shells / vcs / neovim / desktop / ...）
bare-nixos/home/desktop/default.nix    # niri/HM 桌面相关（vicinae、DMS 等）
bare-nixos/home/shells/ ...            # fish/nushell/starship
```

## 本机已有的"防死机"改动（不要意外移除）

2026-09-16 整机卡死（无 swap 内存耗尽 + NVIDIA nvidia_uvm `NV_ERR_NO_MEMORY`）后的修复：

- `configuration.nix`：
  - `zramSwap`：32GB 内存 → 最大 16GB zstd 压缩 swap，让匿名页可回收
  - `services.earlyoom.enable = true`：可用内存/swap < 10% 时提前 OOM-kill
  - `boot.kernel.sysctl`：`vm.min_free_kbytes = 262144`、`vm.swappiness = 100`、`kernel.sysrq = 1`
    （下次卡死可 `Alt+SysRq+S` 同步后 `B` 重启）
- `home/desktop/default.nix`：`programs.vicinae.settings` 把 `repos`、Steam、浏览器 profile、外置盘
  等大目录从文件索引中排除（否则每 60 秒全量扫描 ~15 万文件）

重建后自检：

```bash
swapon --show                     # 应有 /dev/zram0
systemctl status earlyoom --no-pager
sysctl kernel.sysrq vm.swappiness vm.min_free_kbytes
```

## 其他

- `just wsl` / `just orb` 使用 `./nixos#nixos`，只用于 WSL 等环境，**不要**用它改本机。
- `just link` 负责把 `fish/themes`、`starship.toml`、`wezterm.lua` 等软链到 `~/.config`。
