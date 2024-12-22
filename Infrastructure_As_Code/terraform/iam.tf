resource "aws_iam_policy" "CSYE6225_Custom_Policy" {
  name        = "CSYE6225_Custom_Policy"
  description = "Custom IAM Policy for CSYE6225 Web Application"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2Actions"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowS3Access"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowSecretsManagerAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:DeleteSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetResourcePolicy"
        ]
       Resource = "arn:aws:secretsmanager:${var.aws_region}:*:secret:db_password-*"
      },
      {
        Sid    = "AllowKMSUsage"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowKMSKeyManagement"
        Effect = "Allow"
        Action = [
          "kms:CreateKey",
          "kms:PutKeyPolicy",
          "kms:EnableKeyRotation",
          "kms:DescribeKey",
          "kms:ListKeys"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "CSYE6225_EC2_Role" {
  name = "WebAppRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_secrets_manager_access" {
  name        = "LambdaSecretsManagerAccessPolicy"
  description = "Policy to allow Lambda function to retrieve secrets"
  policy      = jsonencode(
   
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:CreateSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
        "secretsmanager:DeleteSecret",
        "secretsmanager:ListSecretVersionIds",
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:ListSecrets"
      ],
      "Resource": aws_secretsmanager_secret.email_credentials.arn
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ScheduleKeyDeletion",
        "kms:EnableKeyRotation",
        "kms:DescribeKey",
        "kms:GenerateDataKey",

      ],
      "Resource": aws_kms_key.email_secrets_key.arn
    }
  ]

    }
    )
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_manager_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_secrets_manager_access.arn
}


resource "aws_iam_role_policy_attachment" "web_app_policy_attachment" {
  role       = aws_iam_role.CSYE6225_EC2_Role.name
  policy_arn = aws_iam_policy.CSYE6225_Custom_Policy.arn
}
resource "aws_iam_role_policy_attachment" "policy-attach2" {
  role       = aws_iam_role.CSYE6225_EC2_Role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "CSYE6225-profile" {
  name = "WebAppProfile"
  role = aws_iam_role.CSYE6225_EC2_Role.name
}
