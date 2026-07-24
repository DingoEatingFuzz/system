datacenter = "home"
data_dir = "/opt/nomad"

client {
  enabled = true
  network_interface = "tailscale0"
  server_join {
    retry_join = [ "olares:4647" ]
  }
}
