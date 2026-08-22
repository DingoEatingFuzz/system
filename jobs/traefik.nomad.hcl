job "traefik" {
  region      = "global"
  datacenters = ["home"]
  type        = "service"

  group "traefik" {
    count = 1

    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }

    network {
      port "http" {
        static = 8080
      }

      port "api" {
        static = 8081
      }

      mode = "host"
    }

    service {
      provider = "nomad"
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v3.6.6"
        network_mode = "host"
        ports = ["http", "api"]

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":8080"
    [entryPoints.traefik]
    address = ":8081"

[api]
    dashboard = true
    insecure  = true

[providers.nomad]
    prefix           = "traefik"
    exposedByDefault = false

[providers.nomad.endpoint]
address = "http://{{ env "attr.unique.advertise.address" }}"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
