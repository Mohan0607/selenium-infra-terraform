# Common variables that are shared by both the infrastructure deployment and the app deployment
local_aws_profile_name = "853973692277_limited-admin"
aws_account_id         = "853973692277"
region                 = "us-east-1"
project_environment    = "testing"
resource_name_prefix   = "testing-md"
project_name           = "Selenium Grid"

# Vpc & Subnets
vpc_cidr_block            = "10.8.0.0/16"
public_subnets_cidr_list  = ["10.8.1.0/24", "10.8.2.0/24"]
private_subnets_cidr_list = ["10.8.3.0/24", "10.8.4.0/24"]

# DNS
load_balancer_domain_name = "testing-api.mohandurai.info"
acm_cert_arn              = "arn:aws:acm:us-east-1:853973692277:certificate/79ca8e19-9581-4584-a5c6-4373a61096a5"

# Ecs
service_discovery_namespace_name = "selenium-ns"

# Cloud Front
cf_aliases = ["testing-dashboard.mohandurai.info"]

# ECS Hub Task Definitions
selenium_hub_image                 = "selenium/hub:4.11.0"
selenium_hub_task_cpu              = 1024
selenium_hub_task_memory           = 2048
selenium_hub_container_cpu         = 1024
selenium_hub_container_memory      = 2048
selenium_hub_service_desired_count = 1
selenium_hub_container_port        = 4444

# ECS Chrome Task Definitions
selenium_chrome_image                 = "selenium/node-chrome:4.11.0"
selenium_chrome_task_cpu              = 1024
selenium_chrome_task_memory           = 2048
selenium_chrome_container_cpu         = 1024
selenium_chrome_container_memory      = 2048
selenium_chrome_service_desired_count = 1

# ROLE OIDC
github_org_name    = "Mohan0607"
github_repo_name   = "selenium-infra-terraform"
github_branch_name = "main"