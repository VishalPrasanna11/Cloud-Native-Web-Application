# Purpose: Define the required Terraform version and provider versions.
terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">5.0.0,<6.0.0"
    }
  }
}