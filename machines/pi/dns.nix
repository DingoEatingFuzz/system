{
  ...
}:
{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      listen-address = [ "192.168.189.4" ];
      interface = "end0";
      bind-interfaces = true;
      no-resolv = true;
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      address = [
        "/home.local/192.168.189.5"
        "/example/192.168.189.5"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
