output "log_archive_bucket_id" {
  description = "The ID of the central log archive S3 bucket."
  value       = aws_s3_bucket.log_archive.id
}