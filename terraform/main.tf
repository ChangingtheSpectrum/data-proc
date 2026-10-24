terraform {
  required_version = ">= 1.5.0"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.16"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

# 1. Upload local public key to Linode
resource "linode_sshkey" "deployer" {
  label   = "dataproc-deployer-key"
  ssh_key = chomp(file(pathexpand(var.public_key_path)))
}

# 2. Provision the Ubuntu 22.04 LTS instance
resource "linode_instance" "dataproc_server" {
  label           = "dataproc-node-01"
  image           = "linode/ubuntu22.04"
  region          = var.region
  type            = var.instance_type
  authorized_keys = [linode_sshkey.deployer.ssh_key]

  tags = ["dataproc", "production"]
}

# 3. Optional perimeter firewall mirroring the AWS Security Group rules
resource "linode_firewall" "dataproc_firewall" {
  label = "dataproc-perimeter-firewall"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "allow-app-port"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "8080"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.dataproc_server.id]
}