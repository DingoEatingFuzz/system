job "zigbee2mqtt" {
  datacenters = ["home"]

  type = "service"

  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "CaacleQNASX"
  }

  group "zigbee2mqtt" {
    restart { attempts = 0 }
    reschedule { attempts = 0 }

    network {
      port "ui" {
        to = 8080
        host_network = "eth"
      }
      mode = "host"
    }

    task "zigbee2mqtt" {
      driver = "docker"

      config {
        image = "ghcr.io/koenkk/zigbee2mqtt:2.14"
        ports = ["ui"]
      }

      env {
        ZIGBEE2MQTT_DATA = "/local/data"
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

      template {
        destination = "/local/data/configuration.yaml"
        data = file("./jobs/zigbee2mqtt/configuration.yaml")
      }

      template {
        destination = "/local/data/configuration.test.yaml"
        data = file("./jobs/zigbee2mqtt/configuration.yaml")
      }
    }
  }
}
