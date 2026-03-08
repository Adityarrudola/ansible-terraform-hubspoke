# Azure DevOps Hub-Spoke CI/CD Infrastructure on Azure

This project demonstrates a **real-world DevOps workflow** including infrastructure provisioning, CI/CD pipelines, secure secret management, and deployment of containerized microservices on **Microsoft Azure**.

The system provisions a **Hub-Spoke cloud architecture** using **Terraform**, deploys **Docker-based microservices** using **Jenkins CI/CD**, and configures infrastructure using **Ansible automation**.

The application stack includes:

- Frontend service — **Nginx container**
- Backend service — **Node.js Express API container**
- **Azure SQL Database**
- **Azure Key Vault for secrets**
- **Azure Container Registry for Docker images**

All components are deployed automatically through **fully automated CI/CD pipelines**.

---

# Architecture Overview

<img width="5806" height="2309" alt="diagram-export-8-3-2026-4_20_43-PM" src="https://github.com/user-attachments/assets/ec0ed7a5-fe80-4ab6-bac8-97fc324316c5" />

### High-Level Flow

```
Developer
   ↓
GitHub Repository
   ↓
Jenkins CI/CD (Docker container)
   ↓
Infrastructure Pipeline
   ↓
Terraform Hub-Spoke Infrastructure Provisioning
   ↓
Backend Deployment Pipeline
Frontend Deployment Pipeline
   ↓
Ansible VM Configuration
   ↓
Docker Containers Deployment
   ↓
User → Nginx → Node API → Azure SQL
```

---

# System Architecture

The system follows a **Hub-Spoke network topology** on Azure.

```
                HUB VNET
                   │
      ┌────────────┼────────────┐
      │            │            │
   ACR          KeyVault     SQL Server
      │                          │
      │                     SQL Database
      │
      │
      │
   VNET PEERING
      │
 ┌───────────────┴───────────────┐
 │                               │
DEV1 (Frontend)              DEV2 (Backend)
Frontend VM                  Backend VM
Nginx Container              Node.js Container
```

### Hub-Spoke Networking

The hub virtual network hosts shared infrastructure resources.

Two spoke networks connect to the hub:

- **Dev1 VNet** (Frontend environment)
- **Dev2 VNet** (Backend environment)

Connectivity is achieved using **bidirectional VNet Peering**.

```
Hub VNet
   │
   ├── Dev1 VNet (Frontend)
   │
   └── Dev2 VNet (Backend)
```

This architecture centralizes shared services such as **ACR, Key Vault, and SQL** while isolating workloads inside spoke environments.

---

# Infrastructure Provisioning

Infrastructure is provisioned using **Terraform modules**.

Terraform directory structure:

```
terraform/
 ├── hub
 ├── dev-1
 ├── dev-2
 └── networking
```

Each module provisions a separate part of the infrastructure.

---

## Hub Environment

Shared infrastructure used by all environments.

| Resource | Purpose |
|--------|--------|
| Azure Container Registry | Stores Docker images |
| Azure Key Vault | Secure secrets storage |
| Azure SQL Server | Managed SQL server |
| Azure SQL Database | Application database |
| Hub Virtual Network | Central network |

---

## Dev1 Environment (Frontend)

```
Dev1 Resource Group
      │
Dev1 Virtual Network
      │
Frontend VM
 ├─ Public IP
 ├─ Managed Identity
 └─ Nginx Docker Container
```

Responsibilities:

- Hosts the frontend UI
- Runs **Nginx container**
- Nginx acts as a **reverse proxy**
- Forwards `/api` requests to the backend service
- Pulls Docker images from Azure Container Registry

---

## Dev2 Environment (Backend)

```
Dev2 Resource Group
      │
Dev2 Virtual Network
      │
Backend VM
 ├─ Public IP
 ├─ Managed Identity
 └─ Node.js Backend Container
```

Responsibilities:

- Runs backend application logic
- Retrieves secrets from Azure Key Vault
- Connects to Azure SQL Database
- Initializes database schema

---

# Terraform State Management

Terraform state is stored remotely in **Azure Storage Account using Azure Blob Storage**.

Benefits include:

- State locking
- Persistent infrastructure state
- Collaboration between engineers
- Safe environment isolation

Remote backend configuration example:

```
backend "azurerm" {
  resource_group_name  = "tfstate-rg"
  storage_account_name = "tfstateaccount"
  container_name       = "tfstate"
  key                  = "hub.tfstate"
}
```

Remote state structure:

```
Azure Storage Account
   │
   └── tfstate container
        ├── hub.tfstate
        ├── dev1.tfstate
        ├── dev2.tfstate
        └── networking.tfstate
```

Each module uses its own state file to prevent conflicts between environments.

---

# CI/CD System

Jenkins runs inside a **custom Docker container** that includes all required DevOps tools.

Installed tools:

- Terraform
- Azure CLI
- Docker
- Ansible
- Git
- Python

---

# Custom Jenkins Docker Image

```dockerfile
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
 curl unzip git python3-pip \
 apt-transport-https ca-certificates \
 gnupg lsb-release docker.io ansible

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg \
 | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
 > /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install -y terraform

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

USER jenkins
```

---

# CI/CD Pipelines

Three Jenkins pipelines orchestrate deployment.

### 1. Infrastructure Pipeline

<img width="960" height="246" alt="Screenshot 2026-03-08 at 4 36 13 PM" src="https://github.com/user-attachments/assets/b4c6c07d-0537-4548-bcf6-7f8871df363d" />

### 2. Backend Deployment Pipeline

<img width="1077" height="235" alt="Screenshot 2026-03-08 at 4 36 55 PM" src="https://github.com/user-attachments/assets/2abd5c06-1271-4226-bb0a-fdaa2c4d709f" />

### 3. Frontend Deployment Pipeline
<img width="1076" height="259" alt="Screenshot 2026-03-08 at 4 36 38 PM" src="https://github.com/user-attachments/assets/131c0593-b570-448f-8779-1f627f32f02e" />

---

# Infrastructure Pipeline

This pipeline provisions all cloud resources.

Stages executed:

```
Terraform Hub
Terraform Dev1
Terraform Dev2
Terraform Networking
```

Resources created include:

- Hub Virtual Network
- Dev1 Virtual Network
- Dev2 Virtual Network
- Hub-Spoke VNet Peering
- Azure Container Registry
- Azure Key Vault
- Azure SQL Server
- Azure SQL Database
- Frontend VM
- Backend VM

---

# Backend Deployment Pipeline

Pipeline stages:

```
1. Build Backend Docker Image
2. Push Image to Azure Container Registry
3. Fetch Backend VM IP from Terraform Output
4. Generate Dynamic Ansible Inventory
5. Execute dev2-playbook.yml
```

Deployment flow:

```
Build → Push → Configure → Deploy
```

---

# Frontend Deployment Pipeline

Pipeline stages:

```
1. Fetch Backend VM IP
2. Inject Backend IP into nginx.conf
3. Build Frontend Docker Image
4. Push Image to Azure Container Registry
5. Fetch Frontend VM IP
6. Generate Dynamic Ansible Inventory
7. Execute dev1-playbook.yml
```

Backend IP injection example:

```
sed -i 's/BACKEND_IP/<backend-ip>/g' nginx.conf
```

---

# Dynamic Ansible Inventory

Terraform outputs the public IP of each VM.

The pipelines dynamically generate the inventory file.

Backend deployment:

```
[dev2]
<backend_vm_ip> ansible_user=azureuser
```

Frontend deployment:

```
[dev1]
<frontend_vm_ip> ansible_user=azureuser
```

---

# Ansible Configuration

Ansible configures VMs and deploys containers.

Roles used:

| Role | Purpose |
|-----|-----|
| common | Updates and prepares the VM |
| docker | Installs Docker engine |
| azure_cli | Installs Azure CLI |
| acr_login | Authenticates to Azure Container Registry using Managed Identity |
| keyvault | Retrieves secrets from Azure Key Vault |
| backend | Deploys backend container |
| frontend | Deploys Nginx container |

---

# Secrets Management

Secrets are securely handled using **Azure Key Vault**.

Workflow:

```
Terraform
   ↓
Generate SQL Credentials
   ↓
Store in Azure Key Vault
   ↓
Backend VM authenticates using Managed Identity
   ↓
Ansible retrieves secrets from Key Vault
   ↓
Secrets injected into Docker containers
```

No credentials are stored inside the repository.

---

# Microservices Architecture

Two containerized services are deployed.

### Frontend Service

```
Nginx Container
```

Responsibilities:

- Serves static frontend UI
- Reverse proxy to backend API

---

### Backend Service

```
Node.js Express API
```

API endpoints:

```
GET /events
POST /book
```

The backend connects to Azure SQL using the **Node.js `mssql` driver** with encrypted connections enabled.

---

# Database Initialization

When the backend container starts:

```
Node API
  ↓
Check if tables exist
  ↓
Create tables if missing
  ↓
Insert initial seed data
```

Tables created:

```
events
bookings
```

---

# Application Runtime Flow

```
User Browser
     │
     ▼
Frontend VM
     │
     ▼
Nginx Container (Reverse Proxy)
     │
     ▼
Node.js Backend Container
     │
     ▼
Azure SQL Database
```

---

# Project Structure

```
.
├── ansible
│   ├── ansible.cfg
│   ├── inventory
│   │   └── hosts.ini
│   ├── playbooks
│   │   ├── dev1-playbook.yml
│   │   └── dev2-playbook.yml
│   ├── roles
│   │   ├── acr_login
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── azure_cli
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── backend
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── common
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── docker
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── frontend
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   └── keyvault
│   │       └── tasks
│   │           └── main.yml
│   └── vars
│       └── secrets.yml
├── Jenkins
│   ├── application
│   │   ├── backend-pipeline
│   │   │   └── Jenkinsfile
│   │   └── frontend-pipeline
│   │       └── Jenkinsfile
│   ├── Dockerfile
│   └── infrastructure
│       └── Jenkinsfile
├── keys
│   └── demo.pub
├── script
│   ├── decommission.sh
│   └── provision.sh
├── services
│   ├── backend
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── server.js
│   └── frontend
│       ├── Dockerfile
│       ├── index.html
│       └── nginx.conf
└── terraform
    ├── dev-1
    │   ├── acr-role.tf
    │   ├── backend.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── remotestate.tf
    │   ├── resourcegroup.tf
    │   ├── variables.tf
    │   ├── vm.tf
    │   └── vnet.tf
    ├── dev-2
    │   ├── acr-role.tf
    │   ├── backend.tf
    │   ├── keyvaultpolicy.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── remotestate.tf
    │   ├── resourcegroup.tf
    │   ├── variables.tf
    │   ├── vm.tf
    │   └── vnet.tf
    ├── hub
    │   ├── backend.tf
    │   ├── containerregistry.tf
    │   ├── keyvault.tf
    │   ├── mssql.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── random.tf
    │   ├── resourcegroup.tf
    │   ├── variables.tf
    │   └── vnet.tf
    └── networking
        ├── ansible_inventory.tf
        ├── backend.tf
        ├── inventory.tpl
        ├── peering.tf
        ├── provider.tf
        ├── remotestate.tf
        └── variables.tf
```

(Full structure omitted here for brevity but matches repository tree.)

---

# Application Output

### Frontend UI

<img width="1455" height="837" alt="Screenshot 2026-03-08 at 1 42 04 PM" src="https://github.com/user-attachments/assets/16df2691-219a-49a6-b5cf-d25652deea70" />

---

# Key Technologies

| Category | Tools |
|------|------|
| Infrastructure | Terraform |
| Cloud | Microsoft Azure |
| CI/CD | Jenkins |
| Configuration | Ansible |
| Containers | Docker |
| Registry | Azure Container Registry |
| Secrets | Azure Key Vault |
| Backend | Node.js |
| Frontend | Nginx |
| Database | Azure SQL |

---

# Future Improvements

- Kubernetes deployment
- GitHub Actions CI/CD
- Prometheus monitoring
- Grafana dashboards
- Auto scaling infrastructure

---

# Author

Aditya Rudola  
DevOps Engineer
