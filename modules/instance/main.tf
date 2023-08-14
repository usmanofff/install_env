# Service accounts

resource "yandex_iam_service_account" "admin" {
  name = "admin"
}

# rights service accounts

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.admin.id}",
  ]
  depends_on = [
    yandex_iam_service_account.admin,
  ]
}

# create access key

resource "yandex_iam_service_account_static_access_key" "static-access-key" {
  service_account_id = yandex_iam_service_account.admin.id
  depends_on = [
    yandex_iam_service_account.admin,
  ]
}

# create srv instance for deploy k8s

resource "yandex_compute_instance" "srv" { 
  name     = "srv"
  hostname = "srv"

  resources {
    cores  = 4
    memory = 12
  }

  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb" # Ubuntu 22.04 LTS
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
       
  }

}

