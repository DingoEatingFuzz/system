{
	auto_https off
	default_bind {{ env "NOMAD_IP_http" }}
}

http://immich.admin.lan {
	reverse_proxy :8080
  rewrite /immich
}

http://admin.lan, http://www.admin.lan {
	respond / "Caddy Powered"
}
