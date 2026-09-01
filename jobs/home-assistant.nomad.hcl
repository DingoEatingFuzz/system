job "home-assistant" {
  datacenters = ["home"]

  group "home-assistant" {
    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }

    volume "config" {
      type = "host"
      source = "ha_config"
    }

    volume "dbus" {
      type = "host"
      source = "dbus"
      read_only = true
    }

    network {
      port "http" { to = "8123" }
    }

    service {
      provider = "nomad"
      name = "home-assistant"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.homeassistant.rule=Path(`/ha`)",
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

    task "home-assistant" {
      driver = "docker"

      resources {
        cpu = 1000
        memory = 2048
      }

      config {
        image = "https://ghcr.io/home-assistant/home-assistant:2026.8.3"
        ports = ["http"]
      }

      env {
        TZ="America/Los_Angeles"
      }

      volume_mount {
        volume = "config"
        destination = "/config"
      }

      volume_mount {
        volume = "dbus"
        destination = "/run/dbus"
        read_only = true
      }
    }
  }
}

