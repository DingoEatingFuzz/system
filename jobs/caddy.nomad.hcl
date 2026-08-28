job "caddy" {
  region = "global"
  datacenters = ["home"]
  type = "service"

  # Receives the local network to reverse proxy LAN services
  group "caddy-lan" {
    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }

    volume "data" {
      type = "host"
      read_only = false
      source = "caddy_lan_data"
    }

    network {
      port "http" {
        static = 80
        host_network = "eth"
      }
      port "tls" {
        static = 443
        host_network = "eth"
      }
    }

    task "caddy" {
      driver = "docker"

      config {
        image = "caddy:2.11-alpine"
        ports = ["http", "tls"]
        network_mode = "host"
        volumes = [
          "local/conf:/etc/caddy"
        ]
      }

      template {
        data = file("./jobs/caddy/tailscale.caddy.tpl")
        destination = "local/conf/Caddyfile"
      }

      volume_mount {
        volume = "data"
        destination = "/data"
      }
    }
  }

  # Receives the ts network to reverse proxy privileged services
  group "caddy-ts" {
    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }

    volume "data" {
      type = "host"
      read_only = false
      source = "caddy_ts_data"
    }

    network {
      port "http" {
        static = 80
      }
      port "tls" {
        static = 443
      }
      mode = "host"
    }

    task "caddy" {
      driver = "docker"

      config {
        image = "caddy:2.11-alpine"
        ports = ["http", "tls"]
        network_mode = "host"
        volumes = [
          "local/conf:/etc/caddy"
        ]
      }

      template {
        data = file("./jobs/caddy/tailscale.caddy.tpl")
        destination = "local/conf/Caddyfile"
      }

      volume_mount {
        volume = "data"
        destination = "/data"
      }
    }
  }
}
