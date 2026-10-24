output "server_public_ip" {
  description = "Public IPv4 address of the Linode instance"
  value       = tolist(linode_instance.dataproc_server.ipv4)[0]
}

output "ssh_command" {
  description = "SSH connection command"
  value       = "ssh -i ${var.public_key_path} root@${tolist(linode_instance.dataproc_server.ipv4)[0]}"
}