# Infrastructure Setup Using Terraform

This document provides instructions on setting up the infrastructure using [Terraform](https://www.terraform.io/) for the project.

## Prerequisites

Ensure the following tools are installed on your system:

1. **Terraform**: [Install Terraform](https://www.terraform.io/downloads.html).
2. **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and configure it by running:
   ```bash
   aws configure
   ```
   You will need access keys with sufficient permissions to create AWS resources.

## Setting Up the Infrastructure

1. **Clone the Repository**

   Clone the repository to your local machine:
   ```bash
   git clone https://github.com/vishal-cloudcomputing/tf-aws-infra.git
   cd tf-aws-infra
   ```

2. **Navigate to the Terraform Directory**

   Navigate to the directory containing Terraform configuration files:
   ```bash
   cd terraform/
   ```

3. **Create a `.tfvars` File**

   You will need to create a `.tfvars` file to define the required variables. Create a file called `terraform.tfvars` in the `terraform/` directory with the following content:

   ```hcl
   aws_region = ""

   vpc_cidr = ""

   public_subnet_cidrs = [
    
   ]

   private_subnet_cidrs = [
     
   ]

   vpc_name = ""
   ```

   These values define the AWS region, the VPC CIDR block, the public and private subnets, and the name of the VPC that will be created.

4. **Initialize Terraform**

   Run the following command to initialize Terraform. This will download the necessary provider plugins and set up your working directory:
   ```bash
   terraform init
   ```

5. **Review the Plan**

   Run the following command to see what resources will be created without actually applying any changes:
   ```bash
   terraform plan
   ```

   This command will display a list of actions Terraform plans to perform. Review this list to ensure everything looks correct.

6. **Apply the Terraform Plan**

   If everything looks good in the plan, apply the changes to provision the infrastructure:
   ```bash
   terraform apply
   ```

   You will be prompted to confirm the action by typing `yes`.

7. **Verify the Infrastructure**

   Once the apply process completes, Terraform will output the details of the created infrastructure (e.g., VPC ID, subnet IDs). You can verify the resources in the AWS Console under the **VPC** and **EC2** services.

## Destroying the Infrastructure

When you're finished with the infrastructure or need to tear it down, use the following command:
```bash
terraform destroy
```
This will remove all the resources created by Terraform.

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.hashicorp.com/resources/terraform-best-practices)
