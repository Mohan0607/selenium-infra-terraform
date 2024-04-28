output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.selenium_ui.id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.selenium_ui.domain_name
}

output "oai_arn" {
  description = "The ARN of the CloudFront Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.selenium_ui.iam_arn # Adjust the resource name accordingly
}

output "cloudfront_distribution_hosted_zone_id" {
  value       = aws_cloudfront_distribution.selenium_ui.hosted_zone_id
  description = "The Hosted zone id for the Cloud front"
}