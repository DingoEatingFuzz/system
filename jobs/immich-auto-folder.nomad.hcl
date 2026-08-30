job "immich-auto-folder" {
  datacenters = ["home"]

  type = "batch"

  parameterized {
    payload = "forbidden"
  }

  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "olares"
  }

  group "sync" {

    # Don't force it, man
    restart { attempts = 0 }
    reschedule { attempts = 0 }

    volume "nix" {
      type = "host"
      source = "nix"
    }

    task "sync" {
      driver = "exec"

      config {
        command = "nix"
        args = ["run", "github:DingoEatingFuzz/immich-folder-album-creator", "/synology/photos", "http://immich/api", "${API_KEY}", "--", "--unattended"]
      }

      volume_mount {
        volume = "nix"
        destination = "/nix"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich-auto-folder" }}
          API_KEY={{ .immich_api_key }}
        {{ end }}
        EOH
      }
    }
  }
}
