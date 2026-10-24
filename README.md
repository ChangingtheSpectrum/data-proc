# Data Processor Microservice Stack

Automated provisioning and configuration management for deploying the containerized Data Processor stack on an Ubuntu 22.04 LTS Linode (Akamai Cloud) instance.

## Architecture
- **Infrastructure:** Linode Compute Instance via Terraform (`linode/linode` provider)
- **Configuration & Deployment:** Ansible (operating without `docker-compose` Python pip package dependencies)
- **Runtime:** Docker Compose v2 CLI plugin managed by a custom systemd unit (`dataproc.service`)
- **Components:**
  - Python 3.10 HTTP backend running securely as non-root host UID 2048 (`dataproc`)
  - Nginx reverse proxy listening on port 8080, mounting configs read-only and logging to host `/var/log/nginx/custom-access.log`

## Prerequisites
- **Terraform:** `>= 1.5.0`
- **Ansible:** `>= 2.14`
  - Required collection: `ansible-galaxy collection install community.general`
- **Linode Account & API Token:** Personal Access Token with Read/Write access to Linodes and Firewalls
- **Local SSH Key Pair:** `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

---

## Quickstart

### 1. Provision Infrastructure with Terraform
Export your Linode API token to your shell environment so Terraform can authenticate:

```bash
export TF_VAR_linode_token="your_linode_api_token_here"

cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Export the public IP address for downstream automation
export SERVER_IP=$(terraform output -raw server_public_ip)
echo "Server provisioned at: $SERVER_IP"
cd ../ansible

# Inject public IP into inventory.ini (configured for root SSH access)
sed -i "s/<SERVER_PUBLIC_IP>/$SERVER_IP/g" inventory.ini

# Run the deployment playbook
ansible-playbook -i inventory.ini deploy.yml
# NOTE: You may need to create an `ansible.cfg` file within the ansible directory with the following contents (my first attempt to run the ansible-playbook failed due to my machine not having the new server in its known_hosts file):
```
[defaults]
host_key_checking = False
inventory = inventory.ini
```

# Verify the deployment
curl -i http://$SERVER_IP:8080

# Teardown
cd terraform
terraform destroy -auto-approve
