job "immich" {
  datacenters = ["home"]
  meta { bonk = 1 }

  group "immich" {
    count = 1

    update {
      # Take down the old version before deploying the new version.
      #
      # This means there will be downtime, but the alternative is
      # tailscale makes an "immich-1" machine which ruins URLs.
      max_parallel = 1
    }

    volume "immich" {
      type = "host"
      read_only = true
      source = "immich"
    }

    volume "immich_upload" {
      type = "host"
      read_only = false
      source = "immich_upload"
    }

    volume "immich_cache" {
      type = "host"
      read_only = false
      source = "immich_cache"
    }

    volume "immich_db" {
      type = "host"
      read_only = false
      source = "immich_db"
    }

    volume "ts_state" {
      type = "host"
      read_only = false
      source = "ts_state_immich"
    }

    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }

    network {
      mode = "bridge"
      port "http" { to = "80" }
      port "ml" { to = "3003" }
      port "redis" { to = "6379" }
      port "db" { to = "5432" }
    }

    service {
      provider = "nomad"
      name = "immich"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.immich.rule=Path(`/immich`)",
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      resources {
        cpu    = 1000
        memory = 8192
      }

      config {
        image = "https://ghcr.io/immich-app/immich-server:v3.1.0"
        ports = ["http"]
      }

      env {
        TZ="America/Los_Angeles"
        IMMICH_PORT=80
        REDIS_HOSTNAME="127.0.0.1"
        REDIS_PORT="${NOMAD_PORT_redis}"
        DB_HOSTNAME="127.0.0.1"
        DB_PORT="${NOMAD_PORT_db}"
        DB_USERNAME="postgres"
        DB_DATABASE_NAME="immich"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich" }}
          DB_PASSWORD={{ .db_password }}
        {{ end }}
        EOH
      }

      volume_mount {
        volume = "immich_upload"
        destination = "/data"
        read_only = false
      }

      volume_mount {
        volume = "immich"
        destination = "/synology/photos"
        read_only = true
      }
    }

    task "machine-learning" {
      driver = "docker"

      resources {
        cpu    = 1000
        memory = 2048
      }

      config {
        image = "https://ghcr.io/immich-app/immich-machine-learning:v3.1.0"
        ports = ["ml"]
      }

      env {
        TZ = "America/Los_Angeles"
        REDIS_HOSTNAME="127.0.0.1"
        REDIS_PORT="${NOMAD_PORT_redis}"
        DB_HOSTNAME="127.0.0.1"
        DB_PORT="${NOMAD_PORT_db}"
        DB_USERNAME="postgres"
        DB_DATABASE_NAME="immich"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich" }}
          POSTGRES_PASSWORD={{ .db_password }}
        {{ end }}
        EOH
      }

      volume_mount {
        volume = "immich_cache"
        destination = "/cache"
        read_only = false
      }
    }

    task "redis" {
      driver = "docker"

      resources {
        cpu    = 250
        memory = 256
      }

      lifecycle {
        hook = "prestart"
        sidecar = true
      }

      config {
        image = "https://docker.io/valkey/valkey:9@sha256:8e8d64b405ce18f41b8e5ee20aa4687a8ed0022d1298f2ce31cdcf3a76e09411"
        ports = ["redis"]
      }
    }

    task "database" {
      driver = "docker"

      resources {
        cpu    = 250
        memory = 1024
        memory_max = 4096
      }

      lifecycle {
        hook = "prestart"
        sidecar = true
      }

      config {
        image="https://ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23"
        ports = ["db"]
      }

      volume_mount {
        volume = "immich_db"
        destination = "/var/lib/postgresql/data"
        read_only = false
      }

      env {
        POSTGRES_USER="postgres"
        POSTGRES_DB="immich"
        POSTGRES_INITDB_ARGS="--data-checksums"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich" }}
          POSTGRES_PASSWORD={{ .db_password }}
        {{ end }}
        EOH
      }
    }

    task "tailscale" {
      driver = "docker"

      resources {
        cpu = 250
        memory = 128
      }

      lifecycle {
        hook = "poststart"
        sidecar = true
      }

      config {
        image = "tailscale/tailscale:stable"
      }

      volume_mount {
        volume = "ts_state"
        destination = "/state"
        read_only = false
      }

      env {
        TS_HOSTNAME = "immich"
        TS_STATE_DIR = "/state"
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOH
        {{ with nomadVar "nomad/jobs/immich" }}
          TS_AUTHKEY={{ .ts_authkey }}
        {{ end }}
        EOH
      }
    }
  }
}

