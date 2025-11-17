# no-cost-multi-tier-aws
No or low cost multi tier AWS infrastructure 

# no-cost-multi-tier-aws

Terraform configuration for building a modular, incremental, and cost-optimized multi-tier AWS architecture.  
Some components are fully implemented, while others are placeholders for future development.

This project is designed to evolve toward a complete production-ready multi-tier environment while keeping the base deployment minimal-cost and easy to extend.

## Current Architecture Status

### Implemented

- VPC configuration
- Public and private subnets
- Route tables, Internet Gateway, NAT Gateway
- Security groups (ALB, NLB, EC2, Lambda, ECS placeholders)
- EC2 Launch Template
- Auto Scaling Group
- Application Load Balancer (ALB)
- Lambda function and basic API Gateway integration
- Centralized locals for naming and tagging
- Outputs for ALB, VPC, subnets, ASG, and more

### Not Implemented Yet (Placeholders)

- jumpbox.tf (Bastion host)
- rds.tf (RDS instance)
- ecs.tf (ECS cluster and services)

## Repository Structure

```
no-cost-multi-tier-aws/
├── alb.tf
├── asg.tf
├── ec2-lt.tf
├── ecs.tf # placeholder
├── jumpbox.tf # placeholder
├── lambda_api.tf
├── locals.tf
├── main.tf
├── nat.tf
├── nlb.tf 
├── outputs.tf
├── rds.tf # placeholder
├── route-tables.tf
├── security-groups.tf
├── subnets.tf
├── user_data.sh
├── variables.tf
└── vpc.tf

```


## Design Principles

- Low cost by default
- Clear separation of components into individual .tf files
- Readable configurations without excessive abstraction
- Easily extensible as future features are enabled
- Minimal blast radius for testing individual components

## Requirements

- Terraform 1.5 or newer
- AWS CLI v2
- IAM permissions to create required AWS resources
- SSH key pair for future Bastion setup (not yet implemented)

