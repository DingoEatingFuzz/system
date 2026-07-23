datacenter = "home"
data_dir = "/opt/nomad"

addresses = {
  http = "{{ GetInterfaceIp \"tailscale0\" }}"
  rpc = "{{ GetInterfaceIp \"tailscale0\" }}"
  serf = "{{ GetInterfaceIp \"tailscale0\" }}"
}

advertise = {
  http = "{{ GetInterfaceIp \"tailscale0\" }}"
  rpc = "{{ GetInterfaceIp \"tailscale0\" }}"
  serf = "{{ GetInterfaceIp \"tailscale0\" }}"
}

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  network_interface = "tailscale0"
}
