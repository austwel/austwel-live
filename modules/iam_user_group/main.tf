resource "aws_iam_group" "this" {
  name = var.group_name
}

resource "aws_iam_policy" "group_policy" {
  name        = var.policy_name
  description = var.policy_description
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.policy_statements
  })
}

resource "aws_iam_group_policy_attachment" "attach" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.group_policy.arn
}

resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)
  name     = each.key
}

resource "aws_iam_user_login_profile" "login_profile" {
  for_each                = toset(var.user_names)
  user                    = each.key
  password_length         = 16
  password_reset_required = true
}

resource "aws_iam_user_group_membership" "membership" {
  for_each = toset(var.user_names)
  user     = each.key
  groups   = [aws_iam_group.this.name]
}