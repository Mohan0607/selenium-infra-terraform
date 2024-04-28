# terraform/modules/selenium_cloudfront/variables.tf

variable "bucket_regional_domain_name" {
  type = string
}

variable "bucket_id" {
  type = string
}

variable "cf_aliases" {
  type    = list(string)
  default = []
}

variable "geo_restriction" {
  description = "The geo restriction configuration."
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }
}

variable "viewer_certificate" {
  description = "The viewer certificate configuration."
  type = object({
    acm_certificate_arn            = string
    ssl_support_method             = string
    minimum_protocol_version       = string
    cloudfront_default_certificate = bool
  })
  default = null # Force the user to specify this, or set an actual default if appropriate
}

variable "default_cache_behavior" {
  description = "The default cache behavior for the distribution."
  type = object({
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    compress               = bool
    cache_policy_id        = string
    viewer_protocol_policy = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
  })
  default = {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = ""
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}