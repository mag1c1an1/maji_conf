set host 127.0.0.1
set port 7890
# set port 8118
set ident $host:$port

function noproxy
    set -e HTTPS_PROXY
    set -e HTTP_PROXY
    set -e ALL_PROXY
end
