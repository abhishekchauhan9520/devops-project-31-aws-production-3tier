# Project 31 — AWS Production 3-Tier Architecture

A production-style AWS architecture implemented with Terraform.

## Architecture

```text
Internet
   |
   v
Application Load Balancer
   |
   +-----------------------+
   |                       |
   v                       v
Private App Subnet A   Private App Subnet B
   |                       |
   +-----------+-----------+
               |
               v
        RDS PostgreSQL
        (private DB subnets)

S3 provides application object storage.

Terraform provisions the full environment.
```

## Design goals

- Two Availability Zones
- Public subnets only for the ALB
- Private application subnets for EC2
- Dedicated database subnets for RDS
- Least-privilege security groups
- Encrypted EBS and RDS storage
- No public database access
- IMDSv2 required for EC2
- S3 bucket with public access blocked
- Optional Session Manager administration instead of public SSH
- Terraform remote-state guidance
- CI runs formatting, validation and plan only

## Safety

This repository does **not** automatically apply infrastructure from CI. AWS resources can incur charges. Review the Terraform plan and set explicit AWS credentials before running `terraform apply`.

## Layout

```text
terraform/
  versions.tf
  providers.tf
  variables.tf
  networking.tf
  security.tf
  alb.tf
  compute.tf
  database.tf
  storage.tf
  outputs.tf
  userdata.sh
  terraform.tfvars.example
scripts/
  plan.sh
  apply.sh
  destroy.sh
tests/
  test_structure.sh
.github/workflows/terraform.yml
```
