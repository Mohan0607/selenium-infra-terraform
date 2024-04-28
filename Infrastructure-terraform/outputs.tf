output "GITHUB_OIDC_ROLE_ARN" {
  value       = module.oidc_role.iam_role_arn
  description = "The ARN (Amazon Resource Name) of the IAM role created for GitHub OIDC authentication."
}

output "SELENIUM_GRID_URL" {
  value       = module.alb_record.record_names
  description = "The DNS names associated with the Application Load Balancer, used as the endpoint URL for the Selenium Grid."
}

output "DASHBOARD_URL" {
  value       = var.cf_aliases
  description = "The custom URL for the dashboard, provided through CloudFront distribution."
}

output "CLOUDFRONT_DISTRIBUTION_ID" {
  value       = module.cloudfront.cloudfront_distribution_id
  description = "The ID of the CloudFront distribution used to serve the dashboard content."
}

output "BUCKET_NAME" {
  value       = module.reports_bucket.bucket_name
  description = "The name of the S3 bucket used for storing reports."
}
