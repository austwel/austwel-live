resource "aws_iam_role" "asg_scaler" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = var.trusted_entity
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "asg_scaling_policy" {
  name = "${var.role_name}-policy"
  role = aws_iam_role.asg_scaler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "asg_scaler_profile" {
  name = var.profile_name
  role = aws_iam_role.asg_scaler.name
}