
# Connect to srv

resource "null_resource" "srv" {

  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.srv.network_interface.0.nat_ip_address
  }
    depends_on = [yandex_compute_instance.srv]

  provisioner "file" {
    source      = "soft/"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "configs/.terraformrc"
    destination = "/home/ubuntu/.terraformrc"
  }
  provisioner "file" {
    source      = "configs/config"
    destination = "/home/ubuntu/config"
  }

  provisioner "file" {
    source      = "scripts/"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "keys/"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "modules/instance/private.variables.tf"
    destination = "/home/ubuntu/private.variables.tf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/install.sh",
      "sudo /home/ubuntu/install.sh",
      "sleep 25",
      "echo COMPLETED_install"
    ]
  }
}
