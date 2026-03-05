![Architecture Diagram](./RtL-architecture-v1.png)

# 🛒 RtlCorp Enterprise Landing Zone
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) 
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

## 📌 The Project Goal
Architecting a secure, scalable, and modular Azure environment for a retail migration. This project demonstrates **Zero-Trust networking** and **Confidential Computing** standards.

## 🗺️ Architecture Diagram
![Architecture](./images/architecture-diagram.png)

## 🏗️ Modular Structure
This project is built using a **Modular Design Pattern** to ensure separation of concerns:
* **Networking Module**: Defines the VNet, Subnets, and Private Endpoint zones.
* **Security Module**: Orchestrates the **Azure Key Vault** and secret lifecycle management.
* **Data Module**: Deploys a SQL Database with `public_network_access_enabled = false`.
* **Compute Module**: Provisions **DC-Series VMs** for hardware-encrypted data-in-use.

## 🔐 Security Features
* **Private Link**: Database communication occurs entirely over the private Microsoft backbone.
* **Hardware Isolation**: Intel SGX enclaves via `Standard_DC1s_v3` instances.
* **Vaulted Secrets**: Credentials injected via Terraform Sensitive Variables + Key Vault.

## 🚀 Deployment
```hcl
# Set your secure password in environment variables
$env:TF_VAR_admin_password = "SecurePassword123!"

# Run the modular build
terraform init
terraform apply -auto-approve
