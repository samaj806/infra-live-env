# Create an IAM OIDC identity provider that trusts GitHub
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazon.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_caller_identity" "current" {}

# Fetch Github's OIDC thumprint
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# This policy allows the IAM OIDC identity provider to assume the IAM role via
# federated authentication.
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubuseraccount.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com", "https://sts.amazonaws.com" 
      ]


      # condition {
      #   test = "StringEquals"
      #   variable = "token.actions.githubusercontent.com:aud "
      #   # The repos and branches defined in var.allowed_repos_branches will be able to assume this IAM role
      #   values = [
      #     for a in var.allowed_repos_branches :
      #     "repo:${a["org"]}/${a["repo"]}:ref:refs/heads/${a["branch"]}"
      #   ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:samaj806/infra-live-env:ref:refs/heads/main"
      ]
    }
  }
}

# variable "allowed_repos_branches" {
#   description = "GitHub repos/branches allowed to assume the IAM role."
#   type = list(object({
#     org = string
#     repo = string
#     branch = string 
#   }))

# Example:
# allowed_repos_branches = [
#  {
#    org  = "samaj"   
#    repo = "terraform-up-and-running"
#    branch = "main"
#  }
# ]
# }

resource "aws_iam_role" "github_actions_terraforms" {
  name               = "GitHubactionsTerraformRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  description = "Role assumed by GitHub Actions for Terraform deployments."
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.github_actions_terraforms.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
