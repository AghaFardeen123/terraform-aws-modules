variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name."
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable object versioning."
  default     = true
}

variable "enable_encryption" {
  type        = bool
  description = "Enable default server-side encryption (SSE-S3)."
  default     = true
}

variable "block_public_access" {
  type        = bool
  description = "Block all public access to the bucket."
  default     = true
}

variable "lifecycle_rules" {
  type = list(object({
    id                                  = string
    enabled                             = bool
    expiration_days                     = optional(number)
    noncurrent_version_expiration_days  = optional(number)
  }))
  description = "Lifecycle rules for object expiration."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket."
  default     = {}
}
