package main

import caddycmd "github.com/caddyserver/caddy/v2/cmd"
import _ "github.com/caddyserver/caddy/v2/modules/standard"
import _ "github.com/mholt/caddy-webdav"

func main() {
	caddycmd.Main()
}
