job "caddy" {
  region = "global"
  datacenters = ["home"]
  type = "service"

  group "caddy" {
    count = 1

    constraint {
      attribute = "${node.unique.name}"
      operator = "="
      value = "olares"
    }
  }
}
