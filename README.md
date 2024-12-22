# Cloud-Native-Web-Application

This repository contains a scalable Cloud-Native Web Application. Users can create accounts, update profiles, upload pictures, and verify email for secure login. Built with cloud-native principles, it uses microservices, containerization, and CI/CD workflows, ensuring high availability and rapid deployment on cloud platforms such as AWS.

## Project Overview

This cloud-native application combines Node.js microservices with AWS serverless architecture and infrastructure as code using Terraform.

## Project Structure

**Serverless_Function**
- `index.mjs` - Source code for Lambda functions

**Infrastructure_As_Code**
- `certificates/` - This folder contains SSL certificates
- `lambda/`- This folder contains the zip file of serverless function as serverless.zip
- `terraform/`-This folder contains the terraform codes to build infrastructures

**Web_Application**
- `infra/` - This folder contains packer build files
- `src/`- Source code of the Node.js application


## Components 
**Web Application**
- Node.js-based REST API with CI/CD pipeline
- Automated testing and AMI based builds
- Template-driven deployment system

**Lambda Functions**
- Email verification service
- Token management with 2-minute expiration
- RDS integration for token storage
- SendGrid integration for email delivery

**Infrastructure Components**

**EC2 Configuration**
- `ec2.tf`
Defines the EC2 instances, including:
- Instance type (e.g., `t2.micro`, `m5.large`).
- AMI selection.
- Key pair configurations.
- Tags and metadata.

**RDS Configuration**
- `rds.tf`
Sets up RDS (Relational Database Service), including:
- Database engine (PostgreSQL).
- Storage configuration (size and type).
- Credentials and access control.

**Lambda Functions**
- `lambda.tf`
Manages AWS Lambda functions, including:
- Runtime environment (e.g., Node.js).
- Function handler and memory allocation.
- Event triggers (e.g., S3, SNS).

**SNS Setup**
- `sns.tf`
Configures Simple Notification Service (SNS):
- Topic creation.
- Subscriptions (e.g., email, Lambda).

**CloudWatch Monitoring**
- `cloudwatch.tf`
Sets up CloudWatch for:
- Metrics and Alarms.
- Logs and monitoring.

**NAT Gateway**
- `nat.tf`
Defines NAT Gateway configurations to:
- Enable internet access for private subnets.

**VPC Configuration**
- `vpc.tf`
Configures the Virtual Private Cloud (VPC):
- CIDR blocks.
- Subnets (private and public).
- Route tables and internet gateways.

**Load Balancer**
- `loadbalancer.tf`
Manages Application or Network Load Balancers:
- Listener configurations.
- Target groups.

**Auto Scaling Groups**
- `autoscaling.tf`
Sets up Auto Scaling Groups:
- Launch configurations.
- Scaling policies.

**IAM Roles and Policies**
-`iam.tf`
Manages Identity and Access Management (IAM):
- Roles for EC2, Lambda, and other services.
- Custom policies for access control.

**Key Management Service**
- `kms.tf`
Configures AWS Key Management Service (KMS):
- Encryption keys.
- Key policies.
  
**CloudWatch Log Groups**
- `logGroup.tf`
Sets up CloudWatch Log Groups:
- Retention policies.
- Logging configurations.
  
**Route 53**
- `route53.tf`
Manages Route 53 DNS configurations:
- Hosted zones.
- Record sets (e.g., A, CNAME).

**Routing Tables**
- `routes.tf`
Defines routing configurations:
- Public and private routes.
- Internet Gateway (IGW) routing.
  
**S3 Buckets**
- `s3.tf`
Configures S3 buckets:
- Versioning and lifecycle rules.
- Bucket policies and encryption.

**Security Groups**
- `securitygroup.tf`
Manages Security Groups:
- Inbound and outbound rules.
- Port and IP restrictions.

**Outputs**
- `outputs.tf`
Exposes outputs for use in other modules:
- EC2 instance IDs.
- S3 bucket names.
- Database connection details.

**Providers**
- `providers.tf`
Defines provider configurations:
- AWS region.
- Authentication setup (via environment or profile).

**Main Configuration**
- `main.tf`
Primary entry point that:
- Links modules and resources.
- Orchestrates the infrastructure components.

## Infrastructure as Code

All AWS resources are managed through Terraform:
- Networking (VPC, NAT, Security Groups)
- Compute (EC2, Lambda)
- Database (RDS)
- Security (IAM roles, policies)
- Monitoring (CloudWatch)

## Deployment

The application uses a multi-stage deployment process:
1. CI/CD pipeline for testing
2. Amazon Machine image creation and push to registry
3. Infrastructure deployment via Terraform
4. Lambda function deployment and configuration

## Security

- Secure key management using AWS Secrets Manager
- IAM roles and policies for least privilege
- VPC security groups for controlled access
- Encrypted data storage with AWS KMS

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/VishalPrasanna11/Cloud-Native-Web-Application.git
   cd Cloud-Native-Web-Application
   ```
2. Configure AWS credentials:
   ```bash
   aws configure
   ```
3. Initialize Terraform:
   ```bash
   cd infrastructure_as_code/terraform
   terraform init
   ```
4. Deploy infrastructure:
   ```bash
   terraform apply
   ```
5. Deploy the web application:
   ```bash
   cd web_application
   npm install
   npm run build
   npm run deploy
   ```
6. Configure Lambda functions and other services as required.

## Prerequisites

- AWS Account
- Terraform installed
- Node.js runtime environment
- AWS CLI configured

## Cloud Architecture

![Cloud_Architecture drawio](https://github.com/user-attachments/assets/cac35332-29a9-46f3-a7b9-f3a3bd82d2bc)

## Acknowledgements

This project was a part of **CSYE6225: Network Structures and Cloud Computing**. We would like to express our gratitude to **Professor Tejas Parikh** for his guidance and support throughout the course.



## License

This project is licensed under the [MIT License](LICENSE).
