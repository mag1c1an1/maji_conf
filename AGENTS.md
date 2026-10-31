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
cd bare-nixos && nix flake update <input>    # 如 nixpkgs / home-manager / warp-ime ...
alejandra bare-nixos/                        # 格式化 nix 文件
```

## 注意事项 / 常见坑

1. **新文件必须先 `git add`**：flake 在 git 仓库中评估时**只看得见已 tracked 的文件**。
   新增 `bare-nixos/home/**/xxx.nix` 后如果没 `git add`，rebuild 会报找不到文件/属性。
   修改已跟踪文件只会提示 `Git tree ... is dirty`（正常现象，不影响构建）。
2. `nixos-rebuild build` 会在仓库里生成 `result` 软链接（未跟踪）；用完删掉，避免误提交。仓库目前没有 `.gitignore`。
3. `bare-nixos/hardware-configuration.nix` 是 `nixos-generate-config` 生成的，非必要不要手改。
4. `system.stateVersion = "25.11"` 不要动。
5. 下载走代理：nix-daemon 环境变量指向 xray 的 `127.0.0.1:10801`（HTTP）/ `127.0.0.1:10800`（SOCKS5），
   `programs.git` 的 `http.proxy` 也是 10801；flake 里已配 USTC / cache.nixos.org，`just bare` 额外用交大镜像。
   备份可用 clash-verge-rev 的 mixed-port `127.0.0.1:7890`（HTTP+SOCKS5 同端口），但它是用户级 GUI 程序，
   没登录/没启动时端口不存在。
   若 rebuild 卡在 fetching 或报 `Nix daemon disconnected unexpectedly`，先确认代理在 listen：
   `ss -ltnp | grep -E '10801|7890'`。
   `xray/client.json` 是带注释的 JSONC，改完必须 `xray run -test -config xray/client.json` 验证，但 **`-test` 不检查
   路由规则里的 tag 是否存在**：删/改 outbound 的 `tag` 后，`routing.rules` 里的 `outboundTag` 必须同步改，否则服务能起来、
   国内直连正常，但所有走代理的连接都被 dispatcher 关掉（debug 日志 `non existing outTag: xxx`，客户端表现为
   `curl: (35) Send failure: Broken pipe`）。历史坑：注释中间漏逗号会报 `invalid character '{' after array element`，服务直接 failed。
6. home-manager 只影响 `maji`；用户级的包和配置都在 `bare-nixos/home/` 下。
7. 新建 home 模块要挂到 `bare-nixos/home/default.nix` 的 `imports` 列表里。

## 配置布局（改哪里）

```
bare-nixos/configuration.nix           # 系统入口（imports: hardware / docker.nix / desktop.nix / ...）
bare-nixos/desktop.nix                 # 桌面环境：niri + DankMaterialShell（dms-greeter）、
                                       # clash-verge、zen-browser（imports: avatar.nix / steam.nix）
                                       # 2026-10-31 从 COSMIC 切回 niri + DMS；输入法 pinyinime 由 niri
                                       # spawn-at-startup 拉起（带 WeType 资源的 wrapper）
bare-nixos/docker.nix                  # Docker
bare-nixos/steam.nix                   # Steam（由 desktop.nix 引入）
bare-nixos/home/default.nix            # home-manager 用户入口（imports: shells / vcs / neovim / desktop / ...）
bare-nixos/home/desktop/default.nix    # 桌面应用、niri/DMS 配置与 pinyinime 启动（wrapper 带 WeType 资源）
bare-nixos/home/shells/ ...            # fish/nushell/starship
```

## 本机已有的"防死机"改动（不要意外移除）

2026-09-16 整机卡死（无 swap 内存耗尽 + NVIDIA nvidia_uvm `NV_ERR_NO_MEMORY`）后的修复：

- `configuration.nix`：
  - `zramSwap`：32GB 内存 → 最大 16GB zstd 压缩 swap，让匿名页可回收
  - `services.earlyoom.enable = true`：可用内存/swap < 10% 时提前 OOM-kill
  - `boot.kernel.sysctl`：`vm.min_free_kbytes = 262144`、`vm.swappiness = 100`、`kernel.sysrq = 1`
    （下次卡死可 `Alt+SysRq+S` 同步后 `B` 重启）

2026-10-24 睡眠唤醒后回不到桌面（NVIDIA 显存内容丢失）后的修复：

- `configuration.nix`：`hardware.nvidia.powerManagement.enable = true;`
  生成 `/etc/modprobe.d/nixos.conf` 里的
  `NVreg_PreserveVideoMemoryAllocations=1 NVreg_UseKernelSuspendNotifiers=1`
  （驱动 595.71.05 open + `hardware.nvidia.open = true` → 走内核 suspend notifier，
  不需要 `nvidia-suspend/resume` systemd 单元）。
  没有它：resume 后 `nvidia-drm` 报 `Failed to apply atomic modeset (-11)` / `Xid 13`，
  合成器的 page flip 全部 `EINVAL`，屏幕黑着回不到桌面。
- **改这个必须重启**，模块参数在 `nvidia` 模块加载时生效（`hardware.nvidia.powerManagement.kernelSuspendNotifier = false` 可退回 systemd 单元方案）。
- `configuration.nix`：`services.udev.extraRules` 给外置盘 aigo S7（USB `3535:1122`，S/N `YS20220271`）
  钉死 `power/control=on` + `autosuspend_delay_ms=-1`。不钉的话睡眠时这块盘会被 USB autosuspend
  挂掉并重新枚举（`USB disconnect` → 变 sdb），旧挂载进入 ext4 `shutdown` 状态（写入 EIO），
  `docker`（`data-root = /home/maji/mobile/docker`）随之起不来，`just bare` 会以 **exit 4** 失败。

niri + DMS 的空闲/挂起（切回 niri 后）：

- DMS 管理锁屏与熄屏：`acMonitorTimeout = 900`（15 分钟熄屏）、`acLockTimeout = 600`
  （10 分钟锁屏）、`acSuspendTimeout = 0`（不自动挂起，避免跑测试时睡掉）。
- `systemd-logind` 侧仍是 `IdleAction=ignore`，空闲动作由 DMS 处理。
- 这些值在 `bare-nixos/home/desktop/default.nix` 的 `programs.dank-material-shell.settings` 里，
  改完 `just bare` 后由 home-manager 写入 DMS 配置。

重建后自检：

```bash
swapon --show                     # 应有 /dev/zram0
systemctl status earlyoom --no-pager
sysctl kernel.sysrq vm.swappiness vm.min_free_kbytes
grep -E 'PreserveVideoMemoryAllocations|UseKernelSuspendNotifiers' /proc/driver/nvidia/params  # 都应为 1
systemctl --user is-active dms.service   # 应为 active（niri 会话内）
sudo rtcwake -m mem -s 20         # 睡 20 秒自动醒；醒来后桌面应正常渲染
```

## 其他

- `just wsl` / `just orb` 使用 `./nixos#nixos`，只用于 WSL 等环境，**不要**用它改本机。
- `just link` 负责把 `fish/themes`、`starship.toml`、`wezterm.lua` 等软链到 `~/.config`。
