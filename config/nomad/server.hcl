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

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  network_interface = "tailscale0"
}
