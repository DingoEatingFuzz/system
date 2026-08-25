job "technitium" {
  region = "global"
  datacenters = ["home"]
  type = "service"

  group "technitium" {
    count = 1

    volume "config" {
      type = "host"
      read_only = false
      source = "technitium_config"
    }

    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "CaacleQNASX"
    }

    network {
      port "admin" {
        static = 5380
        host_network = "eth"
      }
      port "dns" {
        static = 53
        host_network = "eth"
      }
    }

    task "technitium" {
      driver = "docker"

      config {
        image = "technitium/dns-server:15.4.0"
        ports = ["admin", "dns"]
      }

      env {
        DNS_SERVER_DOMAIN = "dns-server"
        DNS_SERVER_WEB_SERVICE_LOCAL_ADDR = "192.168.172.2,127.0.0.1"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/technitium" }}
          DNS_SERVER_ADMIN_PASSWORD={{ .admin_password }}
        {{ end }}
        EOH
      }

      volume_mount {
        volume = "config"
        destination = "/etc/dns"
      }
    }
  }
}
