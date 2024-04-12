variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record. This is typically a globally unique string."
}

variable "record" {
  type = object({
    name = string
    type = string
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  })
  description = "A single DNS record configuration. It should include the record name, type, and optionally an alias configuration if it is an alias record."
}
