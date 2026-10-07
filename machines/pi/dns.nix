{
  ...
}:
{
  networking.hostFiles = [ ./../../config/dnsmaq/hosts.txt ];
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    servers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
