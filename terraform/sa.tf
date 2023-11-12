locals {
  service-accounts = toset([
    "instance-sa",
    "ig-sa"
  ])
  instance-sa-roles = toset([
    "container-registry.images.puller",
    "monitoring.editor",
  ])
  ig-sa-roles = toset([
    "compute.editor",
    "iam.serviceAccounts.user",
    "load-balancer.admin",
    # "vpc.admin",
  ])
}

resource "yandex_iam_service_account" "service-accounts" {
  for_each = local.service-accounts
  name     = each.key
}

resource "yandex_resourcemanager_folder_iam_member" "catgpt-roles" {
  for_each  = local.instance-sa-roles
  folder_id = var.yc_folder_id
  member    = "serviceAccount:${yandex_iam_service_account.service-accounts["instance-sa"].id}"
  role      = each.key
}

resource "yandex_resourcemanager_folder_iam_member" "ig-roles" {
  for_each  = local.ig-sa-roles
  folder_id = var.yc_folder_id
  member    = "serviceAccount:${yandex_iam_service_account.service-accounts["ig-sa"].id}"
  role      = each.key
}
