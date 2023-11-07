resource "yandex_lb_network_load_balancer" "catgpt-lb" {
  name = "catgpt-network-load-balancer"

  listener {
    name = "catgp-listener"
    port = 8080
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.catgpt-ig.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 8080
        path = "/ping"
      }
    }
  }
}
