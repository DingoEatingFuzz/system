nixos-bootstrap:
	@printf "Linking ~/nixos to /etc/nixos...\n\n"
	sudo rm -rf /etc/nixos
	sudo ln -s ~/nixos /etc/nixos
	@printf "\nAlright, run one of these commands to rebuild:\n\n"
	@printf "  sudo nixos-rebuild switch\n"
	@printf "  make rebuild"

rebuild:
	sudo nixos-rebuild switch
  
