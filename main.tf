# Provider

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

# Network

resource "yandex_vpc_network" "srv-network" {
  name = "srv-network"
}

resource "yandex_vpc_subnet" "srv-subnet-1" {
  name           = "srv-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.srv-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  depends_on = [
    yandex_vpc_network.srv-network,
  ]
}

module "kubernetes_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.srv-subnet-1.id
  }