NOMAD_VERSION=2.0.3

bootstrap:
	@printf "Linking ~/system/nixos to /etc/nixos...\n\n"
	sudo rm -rf /etc/nixos
	sudo ln -s ~/system/nixos /etc/nixos
	make post-bootstrap

post-bootstrap:
	@printf "\nAlright, run one of these commands to rebuild:\n\n"
	@printf "  sudo nixos-rebuild switch\n"
	@printf "  make rebuild"

rebuild:
	sudo nixos-rebuild switch

syno-nomad-download:
	@printf "Downloading Nomad v$(NOMAD_VERSION) from releases.hashicorp.com...\n\n"
	curl "https://releases.hashicorp.com/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_linux_amd64.zip" > nomad.zip
	unzip nomad.zip
	rm LICENSE.txt
	chmod +x nomad
	mv nomad /usr/local/bin/

syno-nomad-setup:
	@printf "Setting up a Nomad systemd service...\n\n"
	mkdir -p /etc/nomad.d
	cp -r ./config/nomad/syno.hcl /etc/nomad.d/nomad.hcl
	cp ./syno/nomad.service /usr/local/lib/systemd/system/
	synosystemctl start nomad.service
