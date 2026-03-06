#!/bin/bash

set -e

# HUB
echo "============================"
echo "Provisioning HUB"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/hub/
terraform init
terraform validate 
terraform plan
# terraform apply -auto-approve


# DEV-1
echo "============================"
echo "Provisioning DEV-1"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/dev-1/
terraform init
terraform validate 
terraform plan
# terraform apply -auto-approve

# DEV-2
echo "============================"
echo "Provisioning DEV-2"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/dev-2/
terraform init
terraform validate 
terraform plan
# terraform apply -auto-approve

# DEV-2
echo "============================"
echo "Provisioning Networking"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/networking/
terraform init
terraform validate 
terraform plan
# terraform apply -auto-approve