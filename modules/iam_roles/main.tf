data "aws_iam_policy_document" "main" {
  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid     = statement.value.sid
      effect  = statement.value.effect
      actions = statement.value.actions

      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = length(statement.value.condition) > 0 ? statement.value.condition : []
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}


resource "aws_iam_policy" "main" {
  name        = join("-", [var.resource_name_prefix, var.policy_name, "policy"])
  description = var.policy_description
  policy      = var.iam_policy_json
}

resource "aws_iam_role" "main" {
  name                = join("-", [var.resource_name_prefix, var.role_name, "role"])
  assume_role_policy  = data.aws_iam_policy_document.main.json
  managed_policy_arns = [aws_iam_policy.main.arn]
}

resource "aws_iam_openid_connect_provider" "bitbucket" {
  count           = var.enable_bitbucket_role_oidc ? 1 : 0
  url             = "https://api.bitbucket.org/2.0/workspaces/${var.workspace_name}/pipelines-config/identity/oidc" # Identity Provider URL as displayed in the Bitbucket OpenID Connect Provider page in your repository
  client_id_list  = ["ari:cloud:bitbucket::workspace/${var.workspace_uuid}"]                                        # Identity Provider Audience as displayed in the Bitbucket OpenID Connect Provider page in your repository
  thumbprint_list = [var.oidc_thumbprint]                                                                           # Thumbprint of OIDC host
}
