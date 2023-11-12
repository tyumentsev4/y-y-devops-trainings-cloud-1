output "instance_external_ip" {
  value = "${yandex_compute_instance_group.catgpt-ig.instances.*.network_interface.0.nat_ip_address}"
}

output "instance_group_external_ip" {
  value =  [for listener in yandex_lb_network_load_balancer.catgpt-lb.listener : listener.external_address_spec.*.address][0][0]
}
