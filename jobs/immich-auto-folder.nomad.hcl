job "immich-auto-folder" {
  datacenter = ["home"]

  type = "batch"

  parameterized {
    payload = "forbidden"
  }

  task "sync" {
    driver = "exec2"

    # Clone the repo
    artifact {
      source = "git:https://github.com/DingoEatingFuzz/immich-folder-album-creator"
    }

    # Let nix do the rest (exec2 is configured to have access to the nix store for caching)
    config {
      command = "nix"
      args = ["shell", "./local/repo", "--command", "immich-auto-folder"]
    }
  }
}
