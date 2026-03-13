# config.nu
#
# Installed by:
# version = "0.111.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# alias

alias l = ls -al
alias ll = ls -l
alias zj = zellij
alias lg = lazygit

# path

use std/util "path add"

path add "~/.local/bin"

path add "/opt/homebrew/bin"
path add "~/go/bin"
path add "~/.cargo/bin"
path add "~/opt/local/bin"
path add "~/.local/bin"
path add "/Applications/WezTerm.app/Contents/MacOS"
$env.PATH = ($env.PATH | split row (char esep) | append '/nix/var/nix/profiles/default/bin' | append $"($env.HOME)/.nix-profile/bin" | uniq)

$env.RUST_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"
$env.EDITOR = "nvim"

$env.UV_PATHON_INSTALL_MIRROR = "https://ghfast.top/https://github.com/indygreg/python-build-standalone/releases/download"
$env.UV_DEFAULT_INDEX = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"


# set -gx JAVA_HOME $HOME/Library/Java/JavaVirtualMachines/azul-11.0.25/Contents/Home
#set -gx XMAME_ROOTDIR $HOME/.local/bin
#set -gx XMAME_PROGRAM_DIR $HOME/.local/share/xmake
#
# hadoop
# set -x HADOOP_HOME $HOME/opt/hadoop-3.3.6
# fish_add_path $HADOOP_HOME/bin
# set -x HADOOP_CLASSPATH "$HADOOP_HOME/share/hadoop/tools/lib/*:$(hadoop classpath)"
#
# # flink
# set -x FLINK_HOME $HOME/opt/flink-1.20.1
# fish_add_path $FLINK_HOME/bin
# # spark
# set -x SPARK_HOME $HOME/opt/spark-3.3.2-bin-without-hadoop
# fish_add_path $SPARK_HOME/bin
# set -x SPARK_DIST_CLASSPATH (hadoop classpath)
#

def --env ra [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

let addr = "127.0.0.1:9531"

def --env proxy [] {
    $env.http_proxy = $"socks5h://($addr)"
    $env.https_proxy = $"socks5h://($addr)"
    $env.all_proxy = $"socks5h://($addr)"
}

def --env noproxy [] {
    $env.http_proxy = ''
    $env.https_proxy = ''
    $env.all_proxy  = ''
}

proxy

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

#zoxide init nushell | savae -f ~/.zoxide.nu
source ~/.zoxide.nu
