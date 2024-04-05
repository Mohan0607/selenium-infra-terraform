variable "vpc_id" {
  description = "The VPC ID where the security groups will be created."
  type        = string
}

# variable "security_groups" {
#   description = "A map of security group definitions."
#   type = map(object({
#     name        = string
#     description = string
#     ingress_rules = list(object({
#       description     = string
#       from_port       = number
#       to_port         = number
#       protocol        = string
#       cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
#       security_groups = lookup(ingress.value, "security_groups", null)
#     }))
#   }))
# }
variable "security_groups" {
  description = "A map of security group definitions."
  type = map(object({
    name        = string
    description = string
    ingress_rules = list(object({
      description     = string
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = list(string)
    }))
  }))
}