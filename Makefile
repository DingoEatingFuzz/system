nixos-bootstrap:
	@printf "Linking ~/system/nixos to /etc/nixos...\n\n"
	sudo rm -rf /etc/nixos
	sudo ln -s ~/system/nixos /etc/nixos
	make post-bootstrap

wsl-bootstrap:
	@printf "Linking ~/system/wsl to /etc/nixos...\n\n"
	sudo rm -rf /etc/nixos
	sudo ln -s ~/system/wsl /etc/nixos
	make post-bootstrap

post-bootstrap:
	@printf "\nAlright, run one of these commands to rebuild:\n\n"
	@printf "  sudo nixos-rebuild switch\n"
	@printf "  make rebuild"

rebuild:
	sudo nixos-rebuild switch
  
node-things:
	./nixos/post-install.sh
