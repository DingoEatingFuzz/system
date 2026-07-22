datacenter = "home"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  network_interface = "tailscale0"
}
