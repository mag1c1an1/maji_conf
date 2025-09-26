set host 127.0.0.1
set port 7890
# set port 8118
set ident $host:$port

function proxy
    set -Ux HTTPS_PROXY http://$ident
    set -Ux HTTP_PROXY http://$ident
    set -Ux ALL_PROXY socks5://$ident
end
