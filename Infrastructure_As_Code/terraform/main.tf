# This file contains the main configuration of the infrastructure
# It references the variables defined in variables.tf and the resources defined in vpc.tf
data "aws_availability_zones" "available" {
  state = "available"
}
