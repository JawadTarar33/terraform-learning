variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the S3 bucket"
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_server_side_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the S3 bucket"
  type = list(object({
    enabled = bool
    id      = string
    prefix  = string
    tags    = map(string)
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_transitions = list(object({
      noncurrent_days = number
      storage_class   = string
    }))
    noncurrent_version_expiration = object({
      noncurrent_days = number
    })
    expiration = object({
      days = number
    })
    status = string
  }))
  default = []
}

variable "bucket_public_access_block" {
  description = "Enable public access block for the S3 bucket"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow deletion of all objects in the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = true
}