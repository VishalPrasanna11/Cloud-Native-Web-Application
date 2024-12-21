
resource "aws_cloudwatch_log_group" "csye6225" {
  name              = var.log_group_name
  retention_in_days = 0
}

resource "aws_cloudwatch_log_stream" "webappLogStream" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.csye6225.name
}