data "aws_acm_certificate" "selenium" {
  domain = "*.mohandurai.info"
}

data "aws_route53_zone" "selenium" {
  name = "mohandurai.info"
}

module "vpc" {
  source = "./modules/vpc"

  resource_name_prefix      = var.resource_name_prefix
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnets_cidr_list  = var.public_subnets_cidr_list
  private_subnets_cidr_list = var.private_subnets_cidr_list

}

module "security_groups_alb" {
  source               = "./modules/security_group"
  resource_name_prefix = var.resource_name_prefix

  vpc_id = module.vpc.vpc_id
  security_groups = {
    "alb" = {
      name        = "selenium-lb-sg"
      description = "controls access to the ALB"
      ingress_rules = [
        {
          description     = "HTTP"
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
        },
        {
          description     = "HTTPS"
          from_port       = 443
          to_port         = 443
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
        }
      ]
    }
  }
}

module "security_groups_ecs" {
  source               = "./modules/security_group"
  resource_name_prefix = var.resource_name_prefix

  vpc_id = module.vpc.vpc_id
  security_groups = {
    "ecs_tasks" = {
      name        = "selenium-ecs-sg"
      description = "Allow inbound access from the ALB only"
      ingress_rules = [
        {
          description     = "ECS"
          from_port       = 4444
          to_port         = 4444
          protocol        = "tcp"
          cidr_blocks     = ["${var.vpc_cidr_block}"]
          security_groups = []

        },
        {
          description     = "ECS"
          from_port       = 4444
          to_port         = 4444
          protocol        = "tcp"
          cidr_blocks     = []
          security_groups = module.security_groups_alb.security_group_ids
        },
        {
          description     = "ECS"
          from_port       = 4442
          to_port         = 4442
          protocol        = "tcp"
          cidr_blocks     = ["${var.vpc_cidr_block}"]
          security_groups = []

        },
        {
          description     = "ECS"
          from_port       = 4443
          to_port         = 4443
          protocol        = "tcp"
          cidr_blocks     = ["${var.vpc_cidr_block}"]
          security_groups = []

        },
        {
          description     = "ECS"
          from_port       = 5555
          to_port         = 5555
          protocol        = "tcp"
          cidr_blocks     = ["${var.vpc_cidr_block}"]
          security_groups = []

        }
      ]
    }
  }
  depends_on = [module.security_groups_alb]
}

module "reports_bucket" {
  source               = "./modules/s3"
  resource_name_prefix = join("-", [var.resource_name_prefix, "bucket"])
  aws_account_id       = var.aws_account_id

  bucket_name      = "results"
  versioning       = false
  enable_cors_rule = false

  policy = {
    "Version" : "2012-10-17",
    "Id" : "PolicyForCloudfront",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectAttributes",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:PutBucketAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::${module.reports_bucket.bucket_name}/*",
          "arn:aws:s3:::${module.reports_bucket.bucket_name}"
        ],
        "Principal" : {
          "AWS" : "${module.cloudfront.oai_arn}"
        },
      }
    ]
  }
}

module "cloudfront" {
  source                      = "./modules/cloudfront"
  bucket_regional_domain_name = module.reports_bucket.bucket_regional_domain_name
  bucket_id                   = module.reports_bucket.bucket_id
  cf_aliases                  = var.cf_aliases

  default_cache_behavior = {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = module.reports_bucket.bucket_id
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["US", "CA", "GB", "IN", "DE"]
  }

  viewer_certificate = {
    acm_certificate_arn            = var.acm_cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}

module "selenium_alb" {
  source = "./modules/alb"

  resource_name_prefix        = var.resource_name_prefix
  public_subnet_ids           = module.vpc.public_subnet_ids
  security_group_ids          = concat(module.security_groups_alb.security_group_ids, module.security_groups_ecs.security_group_ids)
  vpc_id                      = module.vpc.vpc_id
  selenium_hub_container_port = 4444
  certificate_arn             = data.aws_acm_certificate.selenium.arn

}
module "role" {
  source               = "./modules/iam_roles"
  resource_name_prefix = var.resource_name_prefix
  policy_name          = "selenium-ecs"
  role_name            = "selenium-ecs"
  policy_description   = "ECS Task Execution Policy"

  iam_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
        ]
        Resource = "*"
      },
    ]
  })

  policy_statements = [
    {
      sid     = "AllowECSTask"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "Service"
          identifiers = ["ecs-tasks.amazonaws.com", "application-autoscaling.amazonaws.com"]
        }
      ]
      condition = []
    }
  ]

}

# You can create here or if already created the identity provider you can ude data block and pass the arn to role
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}

module "oidc_role" {
  source               = "./modules/iam_roles"
  resource_name_prefix = var.resource_name_prefix
  policy_name          = "github-oidc"
  role_name            = "github-oidc"
  policy_description   = "Github OIDC Policy"

  iam_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "s3:*",
          "cloudfront:*"
        ]
        Resource = "*"
      },
    ]
  })

  policy_statements = [
    {
      sid     = "OidcAllow"
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals = [
        {
          type        = "Federated"
          identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
        }
      ]
      condition = [
        {
          test     = "StringLike"
          variable = "token.actions.githubusercontent.com:aud"
          values   = ["sts.amazonaws.com"]
        },
        {
          test     = "StringLike"
          variable = "token.actions.githubusercontent.com:sub"
          values   = ["repo:${var.github_org_name}/${var.github_repo_name}:ref:refs/heads/${var.github_branch_name}"]
        }
      ]
    }
  ]
}

module "cluster" {
  source                = "./modules/ecs_cluster"
  resource_name_prefix  = var.resource_name_prefix
  selenium_cluster_name = "selenium-grid"
  service_namespace_dns = var.service_discovery_namespace_name
}

# Hub
module "hub_service" {
  #service
  source               = "./modules/ecs_service_task"
  cluster_id           = module.cluster.cluster_id
  resource_name_prefix = var.resource_name_prefix
  service_name         = "hub-service"
  desired_count        = var.selenium_hub_service_desired_count
  subnet_ids           = module.vpc.private_subnet_ids
  security_groups      = module.security_groups_ecs.security_group_ids
  assign_public_ip     = true
  service_type         = "hub"

  service_connect_config = [
    {
      namespace = module.cluster.service_discovery_namespace_arn
      enabled   = true
      service = [
        {
          client_alias = {
            port     = 4443
            dns_name = join(".", ["hub", module.cluster.service_discovery_namespace_name])
          }
          port_name      = join("-", ["hub-node-tcp", "4443"])
          discovery_name = join("-", [var.resource_name_prefix, "sub"])
        },
        {
          client_alias = {
            port     = 4442
            dns_name = join(".", ["hub", module.cluster.service_discovery_namespace_name])
          }
          port_name      = join("-", ["hub-node-tcp", "4442"])
          discovery_name = join("-", [var.resource_name_prefix, "pub"])
        }
      ]
  }]

  load_balancer_configuration = [
    {
      target_group_arn = module.selenium_alb.target_group_arn
      container_name   = "hub-node"
      container_port   = 4444
    }
  ]

  # task
  execution_role_arn = module.role.iam_role_arn
  task_role_arn      = module.role.iam_role_arn
  task_cpu           = var.selenium_hub_task_cpu
  task_memory        = var.selenium_hub_task_memory
  containers = [
    {
      name    = "hub-node"
      image   = var.selenium_hub_image
      cpu     = var.selenium_hub_container_cpu
      memory  = var.selenium_hub_container_memory
      command = []
      environments = [
        {
          "name" : "SE_OPTS",
          "value" : "--log-level FINE"
        }
      ]
      ports = [
        {
          containerPort = 4444
          hostPort      = 4444
          protocol      = "tcp"
        },
        {
          containerPort = 5555
          hostPort      = 5555
          protocol      = "tcp"
        },
        {
          containerPort = 4442
          hostPort      = 4442
          protocol      = "tcp"
        },
        {
          containerPort = 4443
          hostPort      = 4443
          protocol      = "tcp"
        }
      ]
      logs = [
        {
          logs_stream_prefix = module.hub_log_group.log_stream_name
          region             = var.region
          loggroup_name      = module.hub_log_group.log_group_name
        }
      ]

    }
  ]
}

module "hub_log_group" {
  source               = "./modules/cloudwatch"
  resource_name_prefix = var.resource_name_prefix
  name_suffix          = "hub"
  retention_in_days    = 30
  cluster_name         = module.cluster.cluster_name
  service_name         = module.hub_service.service_name
  service_type         = "hub"
  high_threshold       = "80"
  low_threshold        = "20"
  high_eval_periods    = "2"
  low_eval_periods     = "2"
  period               = "60"
  statistic            = "Average"
  treat_missing_data   = "missing"

  alaram_scale_down_action_arn = module.hub_autoscaling.alaram_scale_down_action_arn
  alaram_scale_up_action_arn   = module.hub_autoscaling.alaram_scale_up_action_arn
}

module "hub_autoscaling" {
  source                = "./modules/autoscaling"
  cluster_name          = module.cluster.cluster_name
  service_name          = module.hub_service.service_name
  min_capacity          = 1
  max_capacity          = 10
  resource_name_prefix  = var.resource_name_prefix
  service_type          = "hub"
  scale_up_adjustment   = 3
  scale_down_adjustment = -1
}

# Chrome
module "chrome_service" {
  #service
  source               = "./modules/ecs_service_task"
  cluster_id           = module.cluster.cluster_id
  resource_name_prefix = var.resource_name_prefix
  service_name         = "chrome-service"
  desired_count        = var.selenium_chrome_service_desired_count
  subnet_ids           = module.vpc.private_subnet_ids
  security_groups      = module.security_groups_ecs.security_group_ids
  assign_public_ip     = false
  service_type         = "chrome"

  service_connect_config = [
    {
      namespace = module.cluster.service_discovery_namespace_arn
      enabled   = true
  }]

  # task
  execution_role_arn = module.role.iam_role_arn
  task_role_arn      = module.role.iam_role_arn
  task_cpu           = var.selenium_chrome_task_cpu
  task_memory        = var.selenium_chrome_task_memory
  containers = [
    {
      name    = "chrome-node"
      image   = var.selenium_chrome_image
      cpu     = var.selenium_chrome_container_cpu
      memory  = var.selenium_chrome_container_memory
      command = ["/bin/bash", "-c", "PRIVATE=$(curl -s http://169.254.170.2/v2/metadata | jq -r '.Containers[0].Networks[0].IPv4Addresses[0]') ; export SE_OPTS=\"--host $PRIVATE\" ; /opt/bin/entry_point.sh"]
      environments = [
        {
          "name" : "SE_EVENT_BUS_HOST",
          "value" : join(".", ["hub", module.cluster.service_discovery_namespace_name])
        },
        {
          "name" : "SE_EVENT_BUS_PUBLISH_PORT",
          "value" : "4442"
        },
        {
          "name" : "SE_EVENT_BUS_SUBSCRIBE_PORT",
          "value" : "4443"
        },
        {
          "name" : "NODE_MAX_SESSION",
          "value" : "100"
        },
        {
          "name" : "NODE_MAX_INSTANCES",
          "value" : "100"
        },
        {
          "name" : "SE_NODE_MAX_SESSIONS",
          "value" : "2"
        },
        {
          "name" : "SE_VNC_PASSWORD",
          "value" : "openUser"
        },
        {
          "name" : "SE_OPTS",
          "value" : "--log-level FINE"
        }
      ]

      ports = [
        {
          containerPort = 5555
          hostPort      = 5555
          protocol      = "tcp"
        }
      ]
      logs = [
        {
          logs_stream_prefix = module.chrome_log_group.log_stream_name
          region             = var.region
          loggroup_name      = module.chrome_log_group.log_group_name
        }
      ]

    }
  ]
  depends_on = [module.cluster, module.hub_service]
}

module "chrome_log_group" {
  source               = "./modules/cloudwatch"
  resource_name_prefix = var.resource_name_prefix
  name_suffix          = "chrome"
  retention_in_days    = 30
  cluster_name         = module.cluster.cluster_name
  service_name         = module.chrome_service.service_name
  service_type         = "chrome"
  high_threshold       = "80"
  low_threshold        = "20"
  high_eval_periods    = "1"
  low_eval_periods     = "1"
  period               = "60"
  statistic            = "Maximum"
  treat_missing_data   = "breaching"

  alaram_scale_down_action_arn = module.chrome_autoscaling.alaram_scale_down_action_arn
  alaram_scale_up_action_arn   = module.chrome_autoscaling.alaram_scale_up_action_arn
}

module "chrome_autoscaling" {
  source                = "./modules/autoscaling"
  cluster_name          = module.cluster.cluster_name
  service_name          = module.chrome_service.service_name
  min_capacity          = 1
  max_capacity          = 10
  resource_name_prefix  = var.resource_name_prefix
  service_type          = "chrome"
  scale_up_adjustment   = 3
  scale_down_adjustment = -1
}

# dns
module "cf_record" {
  source  = "./modules/route53_records"
  zone_id = data.aws_route53_zone.selenium.id

  record = {
    name = join("", var.cf_aliases)
    type = "A"
    alias = {
      name                   = module.cloudfront.cloudfront_distribution_domain_name
      zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
      evaluate_target_health = true
    }
  }
}

module "alb_record" {
  source  = "./modules/route53_records"
  zone_id = data.aws_route53_zone.selenium.id

  record = {
    name = var.load_balancer_domain_name
    type = "A"
    alias = {
      name                   = module.selenium_alb.alb_dns_domain
      zone_id                = module.selenium_alb.alb_zone_id
      evaluate_target_health = false
    }
  }

}