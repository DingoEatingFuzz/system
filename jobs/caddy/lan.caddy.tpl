{
	auto_https off
	default_bind {{ env "NOMAD_IP_http" }}
}

http://immich.home.lan {
	reverse_proxy olares:8080/immich
}

http://home.lan, http://www.home.lan {
	respond / "Caddy Powered"
}
