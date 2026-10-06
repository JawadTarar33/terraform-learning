# Multi-Tier AWS Infrastructure with Terraform

A modular, production-ready Infrastructure as Code (IaC) project built using **Terraform** on **AWS**. Demonstrates industry-standard directory structuring, zero-trust network isolation, automated IAM bootstrapping, dynamic SSH key pair generation, and a secure multi-tier EC2-to-RDS PostgreSQL architecture.

---

## 🏗️ Architecture Overview

The infrastructure deploys a decoupled, 2-tier architecture within an AWS Virtual Private Cloud (VPC):

```text
                             AWS CLOUD (VPC: 10.0.0.0/16)
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │                                                                             │
 │   PUBLIC SUBNETS (10.0.1.0/24, ...)                                         │
 │   ┌────────────────────────────────┐                                        │
 │   │         EC2 Instance           │ (Internet Gateway)                     │
 │   │   - Ubuntu 22.04 LTS (AMD64)   │ ◄──────── SSH (Port 22 from Admin)     │
 │   │   - Security Group: [ec2_sg]   │                                        │
 │   └───────────────┬────────────────┘                                        │
 │                   │                                                         │
 │                   │ Ingress TCP Port 5432 (PostgreSQL)                      │
 │                   │ (Strictly restricted to ec2_sg)                         │
 │                   ▼                                                         │
 │   PRIVATE SUBNETS (10.0.4.0/24, ...)                                        │
 │   ┌────────────────────────────────┐                                        │
 │   │         RDS Database           │                                        │
 │   │   - PostgreSQL 16 (db.t3.small)│ (NO Internet Access)                   │
 │   │   - Security Group: [rds_sg]   │                                        │
 │   │   - Multi-AZ DB Subnet Group   │                                        │
 │   └────────────────────────────────┘                                        │
 │                                                                             │
 └─────────────────────────────────────────────────────────────────────────────┘
```

### Key Highlights:
- **Zero-Trust Network Isolation**: Database runs entirely in private subnets with no public IP or direct internet access.
- **Least-Privilege Security Group Chaining**: The RDS security group permits inbound traffic on port 5432 **only** from instances associated with `ec2_sg`.
- **Dynamic SSH Credentials**: Generates a 4096-bit RSA key pair dynamically via the Terraform `tls` provider and creates a local `.pem` key file (automatically `.gitignored`).
- **Bootstrap Pattern**: Dedicated IAM automation layer to provision a scoped service user without utilizing AWS root credentials.

---

## 📁 Repository Structure

```text
DEVOPS-LEARNING/
│
├── Terraform/
│   ├── bootstrap/
│   │   └── iam/                # One-time bootstrap: dedicated IAM automation user & API keys
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── providers.tf
│   │
│   ├── modules/                # Reusable, unopinionated blueprints
│   │   ├── vpc/                # VPC, subnets, route tables, IGW
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── ec2/                # Ubuntu EC2 instance, dynamic AMI lookup, key association
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── rds/                # PostgreSQL RDS instance, parameter & subnet groups
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── s3/                 # Ready for cloud storage integration
│   │   └── rds/
│   │
│   └── environments/
│       └── dev/                # Environment-specific orchestration
│           ├── main.tf         # Wires modules together + creates security groups & SSH keys
│           ├── variables.tf    # Dev input variable definitions
│           ├── outputs.tf      # Connection strings, IPs, DNS, and endpoints
│           ├── providers.tf    # AWS provider and minimum version constraints
│           └── terraform.tfvars# Environment values & sensitive variables (git-ignored)
│
├── .gitignore                  # Prevents committing .tfstate, .tfvars, .pem, and .terraform/ cache
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with appropriate credentials)
- Git

### 1. Step 1: Bootstrap IAM Automation (Optional / Recommended)
To avoid using root credentials:
```bash
cd Terraform/bootstrap/iam
terraform init
terraform apply
```
Configure your AWS CLI with the generated keys outputted by Terraform.

---

### 2. Step 2: Deploy Dev Environment
Navigate to the dev environment:
```bash
cd Terraform/environments/dev
```

Create or verify `terraform.tfvars`:
```hcl
aws_region   = "ap-northeast-2"
project_name = "devops-learning"
environment  = "dev"
db_password  = "YourSecurePassword123!"
```

Initialize provider plugins and modules:
```bash
terraform init
```

Preview infrastructure changes:
```bash
terraform plan
```

Deploy the infrastructure:
```bash
terraform apply
```

---

## 🧪 Verification & Connectivity Test

### 1. SSH into the Public EC2 Instance
Terraform outputs your dynamic `.pem` key file in the `dev` directory:
```bash
ssh -i dev-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### 2. Test Connection to Private RDS Database
Once connected inside EC2, install the PostgreSQL client and authenticate:
```bash
sudo apt update -y && sudo apt install -y postgresql-client

psql -h <RDS_ENDPOINT> -U devops -d devopsdb
```
Enter your password when prompted to establish a live session with the database.

---

## 🧹 Tear Down & Cost Cleanup

To destroy all cloud resources and avoid ongoing AWS billing:
```bash
cd Terraform/environments/dev
terraform destroy -auto-approve
```

---

## 🛡️ Security Best Practices Enforced
- Sensitive state files (`*.tfstate`, `*.tfstate.backup`) and secrets (`*.tfvars`, `*.pem`) are strictly excluded from version control via `.gitignore`.
- Database credentials use Terraform's `sensitive = true` flag to prevent plain-text exposure in execution logs.
- Direct SSH and DB traffic are decoupled through layered security group ingress rules.
