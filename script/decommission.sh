#!/bin/bash

set -e

# HUB
echo "============================"
echo "Decommissioning HUB"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/hub/
terraform destroy -auto-approve

# DEV-1
echo "============================"
echo "Decommissioning DEV-1"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/dev-1/
terraform destroy -auto-approve

# DEV-2
echo "============================"
echo "Decommissioning DEV-2"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/dev-2/
terraform destroy -auto-approve

# Networking
echo "============================"
echo "Decommissioning DEV-2"
echo "============================"
cd /Users/adityarudola/Documents/Ansible+Terraform/terraform/networking/
terraform destroy -auto-approve