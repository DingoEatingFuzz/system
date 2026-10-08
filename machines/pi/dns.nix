{
  ...
}:
{
  networking.hostFiles = [ ./../../config/dnsmasq/hosts.txt ];
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings.servers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
