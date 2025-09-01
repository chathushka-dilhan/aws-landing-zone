# Centralized logging setup for AWS Organization
# Assumes that the AWS provider is already configured with appropriate permissions

# Central S3 bucket for all organization logs
resource "aws_s3_bucket" "log_archive" {
  bucket = "org-${var.organization_id}-log-archive"
}

# Block all public access to the log bucket
resource "aws_s3_bucket_public_access_block" "log_archive" {
  bucket                  = aws_s3_bucket.log_archive.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning and object lock for immutability
resource "aws_s3_bucket_versioning" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  object_lock_enabled = "Enabled"
}

# Bucket policy to allow CloudTrail to write objects
data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log_archive.arn}/AWSLogs/${var.organization_id}/*"]
  }
}

resource "aws_s3_bucket_policy" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# Organization-wide CloudTrail trail
resource "aws_cloudtrail" "organization_trail" {
  provider = aws.management # Assumes a provider alias for the management account

  name                          = "Organization-Wide-Trail"
  s3_bucket_name                = aws_s3_bucket.log_archive.id
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
}