terraform {
  required_providers {
      digitalocean = {
          source = "digitalocean/digitalocean"
          version = "~> 2.0"
      }
  }
}

variable "do_token" {}
variable "ssh_key_private" {}
variable "droplet_ssh_key_id" {}
variable "droplet_name" {}
variable "droplet_size" {}
variable "droplet_region" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_vpc" "parcialpavel1" {
    name = "parcialpavel1"
    region = "nyc3"
    ip_range = "10.0.40.0/24"  
}

resource "digitalocean_droplet" "webserver" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name}"
    region = "${var.droplet_region}"
    size   = "${var.droplet_size}"
    vpc_uuid = digitalocean_vpc.parcialpavel1.id
    ssh_keys = ["${var.droplet_ssh_key_id}"]

    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private}")}"
        }
    }
    provisioner "local-exec" {
        environment = {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }
        working_dir = "playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}
resource "digitalocean_droplet" "webserver2" {
    image  = "ubuntu-18-04-x64"
    name   = "${var.droplet_name}"
    region = "${var.droplet_region}"
    size   = "${var.droplet_size}"
    vpc_uuid = digitalocean_vpc.parcialpavel1.id
    ssh_keys = ["${var.droplet_ssh_key_id}"]
}