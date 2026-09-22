job "govee2mqtt" {
  datacenters = ["home"]

  type = "service"

  group "govee2mqtt" {

    network {
      port "udp" {
        static = 4002
        host_network = "eth"
      }
      mode = "host"
    }

    task "govee2mqtt" {
      driver = "docker"

      config {
        image = "ghcr.io/wez/govee2mqtt:latest"
        ports = ["udp"]
        network_mode = "host"
      }

      env {
        GOVEE_MQTT_HOST="192.168.189.2"
        GOVEE_MQTT_PORT=1883
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/govee2mqtt" }}
          GOVEE_API_KEY={{ .govee_api_key }}
          GOVEE_MQTT_USER={{ .mqtt_user }}
          GOVEE_MQTT_PASSWORD={{ .mqtt_password }}
        {{ end }}
        EOH
      }
    }
  }
}
