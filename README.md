# Terra-AWS

Terraform configuration for setting up core AWS infrastructure including:

- VPCs
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.0
- AWS credentials set via environment variables or `~/.aws/credentials`

## VPC Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/FergusJJ/Terra-AWS.git
   cd Terra-AWS/Terraform/Environments/Infra
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Add whitelisted sensitive values to `terraform.tfvars` file and add/remove them from vpc.tf

4. Apply the configuration:

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

5. To destroy the resources:

   ```bash
   terraform destroy
   ```

## Variables

Check `Terraform/Modules/env-vpc/variables.tf` for defaults.

## Outputs

Values such as:

- VPC ID
- Public and private subnet IDs
- Internet Gateway ID
- NAT Gateway ID

See `outputs.tf` for more details.

