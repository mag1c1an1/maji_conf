def --env ra [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# let addr = "localhost"

def --env proxy [] {
    $env.http_proxy = $"http://localhost:10801"
    $env.https_proxy = $"http://localhost:10801"
    $env.all_proxy = $"socks5h://localhost:10800"
}

def --env noproxy [] {
    $env.http_proxy = ''
    $env.https_proxy = ''
    $env.all_proxy  = ''
}

proxy

#mkdir ($nu.data-dir | path join "vendor/autoload")
#starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

#zoxide init nushell | savae -f ~/.zoxide.nu
#source ~/.zoxide.nu
