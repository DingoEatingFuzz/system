datacenter = "home"
data_dir = "/opt/nomad"

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

client {
  enabled = true
  network_interface = "tailscale0"
  server_join {
    retry_join = [ "olares:4647" ]
  }
}
