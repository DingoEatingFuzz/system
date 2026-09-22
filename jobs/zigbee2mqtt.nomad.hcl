job "zigbee2mqtt" {
  datacenters = ["home"]

  type = "service"

  group "zigbee2mqtt" {
    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "CaacleQNASX"
    }

    volume "zigbee2mqtt" {
      type = "host"
      source = "zigbee2mqtt"
    }

    network {
      port "ui" {
        to = 8080
        host_network = "eth"
      }
      mode = "host"
    }

    task "config" {
      driver = "docker"

      lifecycle {
        hook = "prestart"
      }

      config {
        image = "alpine:3"
        args = ["cp", "/local/data/configuration.yaml", "/zigbee2mqtt"]
      }

      volume_mount {
        volume = "zigbee2mqtt"
        destination = "/zigbee2mqtt"
      }

      template {
        destination = "/local/data/configuration.yaml"
        data = file("./jobs/zigbee2mqtt/configuration.yaml")
      }
    }

    task "zigbee2mqtt" {
      driver = "docker"

      resources {
        cpu = 250
        memory = 256
      }

      config {
        image = "ghcr.io/koenkk/zigbee2mqtt:2.14"
        ports = ["ui"]
      }

      env {
        ZIGBEE2MQTT_DATA = "/zigbee2mqtt"
      }

      volume_mount {
        volume = "zigbee2mqtt"
        destination = "/zigbee2mqtt"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/zigbee2mqtt" }}
          ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD={{ .mqtt_password }}
        {{ end }}
        EOH
      }
    }
  }
}
