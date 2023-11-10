data "yandex_compute_image" "coi" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance_group" "catgpt-ig" {
  name               = "catgpt-ig"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.service-accounts["ig-sa"].id
  load_balancer {
    target_group_name = "catgp-tg"
  }
  instance_template {
    platform_id        = "standard-v2"
    service_account_id = yandex_iam_service_account.service-accounts["instance-sa"].id
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    scheduling_policy {
      preemptible = true
    }
    network_interface {
      network_id = yandex_vpc_network.foo.id
      subnet_ids = [yandex_vpc_subnet.foo.id]
      nat        = true
    }
    boot_disk {
      initialize_params {
        type     = "network-hdd"
        size     = "30"
        image_id = data.yandex_compute_image.coi.id
      }
    }
    metadata = {
      docker-compose = file("${path.module}/docker-compose.yaml")
      ssh-keys       = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.catgpt-roles,
    yandex_resourcemanager_folder_iam_member.ig-roles
  ]
}
