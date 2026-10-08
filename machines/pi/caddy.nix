{
  pkgs,
  config,
  ...
}:
{
  services.caddy = {
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20260826180304-de41b249af4f" ];
      hash = "sha256-tR+Da52Ozvwtk7LcCM9DFmDwcKxLd/u+2VmOTs1JFsI=";
    };
    enable = true;
    configFile = ./../../config/caddy/local.caddy;
    environmentFile = ''
      TS_AUTHKEY=${config.services.onepassword-secrets.secretPaths.tsAuthKey}
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  environment.variables = {
    TS_AUTHKEY = "tskey-auth-kga8nuYgtW11CNTRL-6cSrLS7CgARZ965Ph7NEARZkZgyBS4gG";
  };
}
