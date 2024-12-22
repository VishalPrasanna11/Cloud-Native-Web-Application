resource "aws_lambda_function" "user_verification_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  timeout       = 60
  memory_size   = 128
  # Reference the Lambda code from the local file
  filename = "${path.module}/${var.lambda_file_path}"
  environment {
    variables = {
       SECRET_NAME = aws_secretsmanager_secret.email_credentials.name
    }
  }

}
resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.email_verification.arn
}
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publish-policy"
  description = "Policy to allow EC2 instance to publish to SNS topic"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : "${aws_sns_topic.email_verification.arn}"
      }
    ]
  })
}


# resource "aws_kms_alias" "lambda_custom_key_alias" {
#   name          = "alias/lambda-email-key"
#   target_key_id = aws_kms_key.lambda_custom_key.id
# }
resource "aws_secretsmanager_secret" "email_credentials" {
  name        = "lambda-email-credentials-${random_id.rds_password_id.hex}"
  description = "Email credentials for the Lambda function"
  kms_key_id  = aws_kms_key.email_secrets_key.id
}

resource "aws_secretsmanager_secret_version" "email_credentials_version" {
  secret_id     = aws_secretsmanager_secret.email_credentials.id
  secret_string = jsonencode({
    MAILGUN_API_KEY      = var.mailgun_api_key
    MAILGUN_DOMAIN       = var.mailgun_domain
    MAILGUN_FROM_ADDRESS = var.mailgun_from_address
  })
}


# Attach SNS publish policy to the EC2 role
resource "aws_iam_role_policy_attachment" "attach_sns_publish_policy" {
  role       = aws_iam_role.CSYE6225_EC2_Role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "cloudwatch-logs-policy"
  description = "Policy to allow Lambda to create and write logs to CloudWatch"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}