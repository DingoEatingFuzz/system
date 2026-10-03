{
  config,
  pkgs,
  local,
  system,
  ...
}:
let
  nomad = local.packages.${system}.nomad;
  cni = import ./../../lib/cni.nix { inherit pkgs; };
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Don't let systemd hang reboots
  systemd.settings.Manager = {
    RebootWatchdogSec = "10s";
  };

  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
    # TODO: Nomad service
  };

  networking.hostName = "pi"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  networking.useNetworkd = true;
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
  };

  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"

  '';

  virtualisation = {
    docker.enable = true;
    docker.package = pkgs.docker_29;
  };

  environment.systemPackages = with pkgs; [
    tree
    cni-plugins
    vim
    git
    gnumake
    _1password-cli
  ];

  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
  };

  nixpkgs.config.allowUnfree = true;

  users.users.pi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq7TXOCAWe5kyK4dwEdPrXuMhN3yyq8Glt0rsrbo8u8"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq7TXOCAWe5kyK4dwEdPrXuMhN3yyq8Glt0rsrbo8u8"
  ];

  services.getty.autologinUser = "pi";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  nix.settings.trusted-users = [ "pi" ];

  system.nixos.tags = [
    "raspberry-pi-${config.boot.loader.raspberry-pi.variant}"
    config.boot.loader.raspberry-pi.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  system.stateVersion = "26.05";
}
