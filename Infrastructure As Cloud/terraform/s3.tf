# Generate UUID for S3 bucket name
resource "random_uuid" "bucket_uuid" {}

# Create a private S3 bucket with unique UUID name and forced deletion
resource "aws_s3_bucket" "csye6225_bucket" {
  bucket        = random_uuid.bucket_uuid.result
  force_destroy = true

}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "blocking_public_access" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply default encryption (AES256) for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"                 # Use KMS encryption instead of AES256
      kms_master_key_id = aws_kms_key.s3_key.key_id # Reference the KMS key
    }
  }
}

# S3 Bucket Lifecycle Policy to transition objects to STANDARD_IA
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_policy" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
