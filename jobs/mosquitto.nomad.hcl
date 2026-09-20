job "mosquitto" {
  datacenters = ["home"]

  type = "service"

  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "CaacleQNASX"
  }

  group "mosquitto" {
    restart { attempts = 0 }
    reschedule { attempts = 0 }

    network {
      port "tcp" {
        static = 1883
        host_network = "eth"
      }
      mode = "host"
    }

    task "mosquitto" {
      driver = "docker"

      config {
        image = "eclipse-mosquitto:2.1-alpine"
        ports = ["tcp"]
        volumes = ["local/mosquitto/config:/mosquitto/config"]
      }

      template {
        destination = "local/password_file"
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/mosquitto-docker" }}
          {{ .password_file }}
        {{ end }}
        EOH
      }

      template {
        data = file("./jobs/mosquitto/mosquitto.conf")
        destination = "local/mosquitto/config/mosquitto.conf"
      }
    }
  }
}
