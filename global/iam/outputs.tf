output "all_arns" {
  value       = aws_iam_user.users[*].arn
  description = "The ARNs for all users."
}
