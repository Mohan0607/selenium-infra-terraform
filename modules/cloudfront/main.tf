# terraform/modules/selenium_cloudfront/main.tf

locals {
  selenium_ui_cloudfront_comment = title("Dxc Testing Selenium Portal")
}

resource "aws_cloudfront_origin_access_identity" "selenium_ui" {
  comment = local.selenium_ui_cloudfront_comment
}

resource "aws_cloudfront_distribution" "selenium_ui" {
  comment         = local.selenium_ui_cloudfront_comment
  enabled         = true
  is_ipv6_enabled = true
  aliases         = var.cf_aliases

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.selenium_ui.cloudfront_access_identity_path
    }
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }


  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]
    content {
      allowed_methods        = default_cache_behavior.value.allowed_methods
      cached_methods         = default_cache_behavior.value.cached_methods
      target_origin_id       = default_cache_behavior.value.target_origin_id
      compress               = default_cache_behavior.value.compress
      cache_policy_id        = default_cache_behavior.value.cache_policy_id
      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = default_cache_behavior.value.min_ttl
      default_ttl            = default_cache_behavior.value.default_ttl
      max_ttl                = default_cache_behavior.value.max_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.viewer_certificate.acm_certificate_arn
    ssl_support_method             = var.viewer_certificate.ssl_support_method
    minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
    cloudfront_default_certificate = var.viewer_certificate.cloudfront_default_certificate
  }
}
