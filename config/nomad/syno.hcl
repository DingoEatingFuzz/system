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

  host_volume "technitium_config" {
    path = "/opt/technitium/config"
    read_only = false
  }
}

# All cert files must first be pulled from 1password
tls {
  ca_file = "/nomad/nomad-agent-ca.pem"
  cert_file = "/nomad/global-client-nomad.pem"
  key_file = "/nomad/global-client-nomad-key.pem"

  verify_server_hostname = true
  verify_https_client = true
}

plugin "docker" {
  config {
    allow_privileged = true
    volumes {
      enabled = true
    }
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
