provider "null" {}

variable "remote_user" {
  default = "root"
}

variable "server1_ip" {
  default = "192.168.3.46"
}

variable "server2_ip" {
  default = "192.168.1.250"
}

variable "private_key_path" {
  default = "C:/Users/1614/.ssh/id_ed25519"
}

variable "file_path_on_server1" {
  default = "/u01/backup_latest/*.tar"
}

variable "destination_path_on_server2" {
  default = "/u01/files_from_infratraining3svr/"
}

resource "null_resource" "copy_from_server1_to_server2" {
  provisioner "remote-exec" {
    inline = [
      "scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ${var.file_path_on_server1} ${var.remote_user}@${var.server2_ip}:${var.destination_path_on_server2}"
    ]

    connection {
      type        = "ssh"
      host        = var.server1_ip
      user        = var.remote_user
      private_key = file(var.private_key_path)
      timeout = "90m" # Increase as needed
    }
  }
}
