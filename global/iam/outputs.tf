output "all_arns" {
  value       = values(aws_iam_user.users)[*].arn
  description = "The ARNs for all users."
}
