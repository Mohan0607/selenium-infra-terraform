variable "resource_name_prefix" {
  type        = string
  description = "Prefix for the resource names."
}
# policy
variable "policy_description" {
  type        = string
  description = "Description for the IAM policy."
}
variable "policy_name" {
  type        = string
  description = "Name of the IAM policy."
}
variable "iam_policy_json" {
  type        = string
  description = "IAM policy document in JSON format."
}

# role
variable "role_name" {
  type        = string
  description = "Name of the IAM Role."
}
# data statement
variable "policy_statements" {
  description = "List of policy statements"
  type = list(object({
    sid     = string
    effect  = string
    actions = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
    condition = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
}

# OIDC 
variable "enable_bitbucket_role_oidc" {
  description = "Flag to enable the Bitbucket role OIDC."
  type        = bool
}

variable "workspace_name" {
  description = "The Bitbucket workspace name."
  type        = string
  default     = ""
}

variable "workspace_uuid" {
  description = "The UUID of the Bitbucket workspace."
  type        = string
  default     = ""
}

variable "oidc_thumbprint" {
  description = "The thumbprint of the OIDC."
  type        = string
  default     = "a031c46782e6e6c662c2c87c76da9aa62ccabd8e"
}
