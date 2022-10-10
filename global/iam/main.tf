terraform {
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch_full_access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

output "all_users" {
  value = values(aws_iam_user.example)[*].arn
}

# resource "aws_iam_policy_attachment" "neo_cloudwatch_full_access" {
#   count = var.give_neo_cloudwatch_full_access ? 1 : 0
#
#   user       = aws_iam_user.example.name
#   policy_arn = aws_iam_policy.cloudwatch_full_access.arn
# }
#
# resource "aws_iam_policy_attachment" "neo_cloudwatch_read_only" {
#   count = var.give_neo_cloudwatch_full_access ? 0 : 1
#
#   user       = aws_iam_user.example.name
#   policy_arn = aws_iam_policy.cloudwatch_full_access.arn
# }

# output "neo_cloudwatch_policy_arn" {
#   value = one(concat(
#     aws_iam_policy_attachment.neo_cloudwatch_full_access[*].policy_arn,
#     aws_iam_policy_attachment.neo_cloudwatch_read_only[*].policy_arn,
#   ))
# }


output "for_directive_index_if_else_strip" {
  value = <<EOF
%{~ for i, name in var.user_names ~}
${name}%{ if i < length(var.user_names) - 1 }, %{ else }.%{ endif }
%{~ endfor ~}
EOF
}

