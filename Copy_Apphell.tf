provider "null" {}

variable "server1_ip" {
  default = "192.168.3.46"
}

variable "server2_ip" {
  default = "192.168.1.250"
}

variable "remote_user" {
  default = "root"
}

variable "private_key_path" {
  default = "C:/Users/1614/.ssh/id_ed25519"
}

resource "null_resource" "zip_and_copy_files" {
  # Step 1: Zip files on server1
  provisioner "remote-exec" {
    inline = [
      "cd /u01/app/APPSHELL/",
      "zip -r appshell_backup.zip ."
    ]

    connection {
      type        = "ssh"
      host        = var.server1_ip
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }
  }

  # Step 2: Copy the zip file from server1 to server2
  provisioner "file" {
    source      = "/u01/app/APPSHELL/appshell_backup.zip"
    destination = "/u01/app/APPSHELL/appshell_backup.zip"

    connection {
      type        = "ssh"
      host        = var.server2_ip
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }
  }

  # Step 3: Unzip files on server2
  provisioner "remote-exec" {
    inline = [
      "cd /u01/app/APPSHELL/",
      "unzip -o appshell_backup.zip",
      "rm -f appshell_backup.zip" # Optional: Remove the zip file after extraction
    ]

    connection {
      type        = "ssh"
      host        = var.server2_ip
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }
  }
}