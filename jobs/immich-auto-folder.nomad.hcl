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
      read_only = false
    }

    task "sync" {
      driver = "exec"

      config {
        command = "nix"
        args = ["run", "github:DingoEatingFuzz/immich-folder-album-creator"]
      }

      volume_mount {
        volume = "nix"
        destination = "/nix"
        read_only = false
      }
    }
  }
}
