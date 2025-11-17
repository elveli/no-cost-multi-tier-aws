# no-cost-multi-tier-aws
No or low cost multi tier AWS infrastructure 

# AWS Multi-Tier Infrastructure (Terraform)

This Terraform project builds a **multi-tier AWS infrastructure** featuring public and private subnets, an Application Load Balancer (ALB), backend Auto Scaling Group, RDS database, Bastion host, and Secrets Manager integration for secure credential storage.

---

## 🏗️ **Architecture Overview**

The infrastructure consists of three logical tiers:

| Tier | Description | AWS Components |
|------|--------------|----------------|
| **Public Tier** | Internet-facing layer with ALB and Bastion (Jump Host) | Application Load Balancer, Bastion EC2, Internet Gateway |
| **Private App Tier** | Scalable backend services | EC2 Auto Scaling Group (private subnets), Step Scaling Policy |
| **Database Tier** | Secure data layer | Amazon RDS (MySQL), Secrets Manager for DB password |

Network flow:
- Internet → **ALB** → **Backend EC2s (private)** → **RDS (private DB subnets)**  
- SSH Access → **Bastion Host (public subnet)** → **Private EC2s**  
- Outbound internet from private tier via **NAT Gateway**

---

## 🧩 **File Structure**

multi-tier-aws/
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
│
├── vpc.tf
├── subnets.tf
├── igw_nat.tf
├── security-groups.tf
│
├── alb.tf
├── asg_backend.tf
├── bastion.tf
│
├── rds.tf
├── secrets.tf
├── scaling_policies.tf
│
└── README.md


### Key Modules

| File | Purpose |
|------|----------|
| `vpc.tf` | Defines VPC and core networking |
| `subnets.tf` | Creates public, private, and DB subnets |
| `igw_nat.tf` | Configures Internet Gateway, NAT Gateway, and routes |
| `security-groups.tf` | Security groups for ALB, EC2, RDS, and Bastion |
| `alb.tf` | Application Load Balancer + target group setup |
| `asg_backend.tf` | Auto Scaling Group for backend EC2s |
| `bastion.tf` | Jump host in public subnet for SSH access |
| `rds.tf` | RDS instance deployment (MySQL) |
| `secrets.tf` | Secrets Manager for DB credentials |
| `scaling_policies.tf` | Step scaling policies for backend tier |

---

## ⚙️ **Requirements**

| Tool | Version |
|------|----------|
| Terraform | ≥ 1.5.0 |
| AWS CLI | ≥ 2.0 |
| AWS Account | With appropriate IAM permissions |
| Key Pair | Existing SSH key for EC2 access (`key_name` variable) |

---



---

## 🚀 **Usage**

### 1. Clone the repository
```bash
git clone https://github.com/your-org/multi-tier-aws.git
cd multi-tier-aws

