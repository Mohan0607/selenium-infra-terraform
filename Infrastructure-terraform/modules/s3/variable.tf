variable "resource_name_prefix" {
  type        = string
  description = "Resource name prefix"
}
variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}
variable "bucket_name" {
  type        = string
  description = "Bucket Name"
}

variable "versioning" {
  type        = bool
  default     = false
  description = "(Optional, Default: false) A boolean to enable versioning"
}

variable "policy" {
  description = "(Optional) The policy statements to attach to the S3 bucket"
  type        = any
  default     = null
}

variable "cors_rule" {
  description = "(Optional List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "enable_cors_rule" {
  type        = bool
  default     = false
  description = "(Optional, Default: false) A boolean to enable cors rule"
}