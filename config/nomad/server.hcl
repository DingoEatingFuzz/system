datacenter = "home"
data_dir = "/opt/nomad"
# Plugin dir is dynamic (nix things) and passed via systemd command
# plugin_dir = "/opt/nomad/plugins"

addresses = {
  http = "{{ GetInterfaceIP \"tailscale0\" }}"
  rpc = "{{ GetInterfaceIP \"tailscale0\" }}"
  serf = "{{ GetInterfaceIP \"tailscale0\" }}"
}

advertise = {
  http = "{{ GetInterfaceIP \"tailscale0\" }}"
  rpc = "{{ GetInterfaceIP \"tailscale0\" }}"
  serf = "{{ GetInterfaceIP \"tailscale0\" }}"
}

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  network_interface = "tailscale0"
}

# All cert files must first be pulled from 1password
tls {
  ca_file = "/nomad/nomad-agent-ca.pem"
  cert_file = "/nomad/global-server-nomad.pem"
  key_file = "/nomad/global-server-nomad-key.pem"

  verify_server_hostname = true
  verify_https_client = true
}
