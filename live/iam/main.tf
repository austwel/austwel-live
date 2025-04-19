module "access" {
  source          = "../../modules/iam_user_group"

  group_name          = "asg-scalers"
  policy_name         = "ASGScalePolicy"
  policy_description  = "Allow members to scale ASGs"

  policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:DescribeScalingActivities"
      ]
      Resource = "*"
    },
    {
      Effect = "Allow"
      Action = [
        "ec2:DescribeInstances",
        "ec2:DescribeVolumes"
      ]
      Resource = "*"
    }
  ]

  user_names = [
    "Tom",
    "Sam",
    "Winston",
    "Box",
    "Lachlan",
    "Josh"
  ]
}