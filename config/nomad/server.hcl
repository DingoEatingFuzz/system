datacenter = "home"
data_dir = "/opt/nomad"

# plugin_dir is dynamic (nix things) and passed via systemd command

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

  cni_path = "/opt/cni/bin"
  cni_config_dir = "/opt/cni/config"

  host_volume "immich" {
    path = "/mnt/photo"
    read_only = false
  }

  host_volume "immich_cache" {
    path = "/opt/immich/cache"
    read_only = false
  }

  host_volume "immich_db" {
    path = "/opt/immich/postgres"
    read_only = false
  }

  host_volume "caddy_ts_data" {
    path = "/opt/caddy/data_ts"
    read_only = false
  }

  host_volume "caddy_lan_data" {
    path = "/opt/caddy/data_lan"
    read_only = false
  }

  host_network "eth" {
    interface = "enp129s0"
  }
}

# All cert files must first be pulled from 1password
tls {
  ca_file = "/nomad/nomad-agent-ca.pem"
  cert_file = "/nomad/global-server-nomad.pem"
  key_file = "/nomad/global-server-nomad-key.pem"

  verify_server_hostname = true
  verify_https_client = true
}

plugin "docker" {
  allowed_caps = ["net_admin"]
}

plugin "nomad-driver-podman" {
  config {
    volumes {
      enabled = true
    }
  }
}

plugin "nomad-driver-virt" {
  config {
    emulator {
      uri      = "qemu:///system"
      user     = ""
      password = ""
    }
  }
}

