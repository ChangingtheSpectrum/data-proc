variable "linode_token" {
  description = "Linode APIv4 Personal Access Token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Linode deployment region"
  type        = string
  default     = "us-east" # Newark, NJ
}

variable "instance_type" {
  description = "Linode instance plan"
  type        = string
  default     = "g6-nanode-1" # 1 vCPU, 1GB RAM, 25GB Storage (~$5/mo)
}

variable "public_key_path" {
  description = "Path to local SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}