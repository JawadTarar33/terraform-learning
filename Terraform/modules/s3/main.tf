module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = var.bucket_name
  tags   = var.tags

  force_destroy = var.force_destroy

  versioning = {
    enabled = var.enable_versioning
  }

  server_side_encryption_configuration = var.enable_server_side_encryption ? {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  } : {}

  block_public_acls       = var.bucket_public_access_block
  block_public_policy     = var.bucket_public_access_block
  ignore_public_acls      = var.bucket_public_access_block
  restrict_public_buckets = var.bucket_public_access_block

  lifecycle_rule = var.lifecycle_rules
}