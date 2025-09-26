if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a ls lsd
abbr -a lt lsd --tree
abbr -a ll lsd -l
abbr -a l lsd -al
abbr -a lg lazygit
abbr -a zj zellij
abbr -a jt just

set BREW_HOME /opt/homebrew

# bind
bind \cg accept-autosuggestion

# PATH

fish_add_path $HOME/.local/bin
fish_add_path $HOME/software/local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $BREW_HOME/bin

# psql
fish_add_path $BREW_HOME/opt/libpq/bin
# scala
# fish_add_path /opt/homebrew/opt/scala@2.12/bin
# set -x SCALA_HOME /opt/homebrew/opt/scala@2.12
#
# flink
fish_add_path $HOME/Downloads/flink-1.20.1/bin
# spark
fish_add_path $HOME/Downloads/spark-3.3.3-bin/bin
# hadoop
fish_add_path $HOME/Downloads/hadoop-3.3.6/bin

# vcpkg
#set VCPKG_ROOT /Users/mag1cian/dev/vcpkg
#fish_add_path $VCPKG_ROOT

# yazi
function ra
    set tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# llvm
#fish_add_path $BREW_HOME/opt/llvm@16/bin
#set -x LDFLAGS "-L/opt/homebrew/opt/llvm@16/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm@16/lib/c++"
#set -x CPPFLAGS "-I/opt/homebrew/opt/llvm@16/include"

# RUST
set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"

# editor
set -gx EDITOR nvim

# xmake
set -gx XMAME_ROOTDIR $HOME/.local/bin
set -gx XMAME_PROGRAM_DIR $HOME/.local/share/xmake

# JAVA
set -gx JAVA_HOME $HOME/Library/Java/JavaVirtualMachines/azul-11.0.25/Contents/Home

# NEMU
set -gx NEMU_HOME /Users/mag1cian/dev/ics2024/nemu
set -gx AM_HOME /Users/mag1cian/dev/ics2024/abstract-machine

# uv
set -gx UV_PYTHON_INSTALL_MIRROR "https://ghfast.top/https://github.com/indygreg/python-build-standalone/releases/download"

# hadoop
set -gx HADOOP_CLASSPATH (/Users/mag1cian/Downloads/hadoop-3.3.6/bin/hadoop classpath)

# spark
set -gx SPARK_DIST_CLASSPATH (hadoop classpath)

# huggingface
set -gx HF_ENDPOINT https://hf-mirror.com

proxy

# zoxide
zoxide init fish | source

# starship
starship init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/mag1cian/miniconda3/bin/conda
    eval /Users/mag1cian/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/Users/mag1cian/miniconda3/etc/fish/conf.d/conda.fish"
        . "/Users/mag1cian/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /Users/mag1cian/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :
