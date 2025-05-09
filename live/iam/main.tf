module "access" {
  source          = "../../modules/iam_user_group"

  group_name          = "ec2-users"
  policy_name         = "EC2UserPolicy"
  policy_description  = "Allow members to use EC2"

  policy_statements = [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {}
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:*",
      "Resource": "*",
      "Condition": {}
    },
    {
      "Effect": "Allow",
      "Action": "cloudwatch:*",
      "Resource": "*",
      "Condition": {}
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:*",
      "Resource": "*",
      "Condition": {}
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": [
            "autoscaling.amazonaws.com",
            "ec2scheduled.amazonaws.com",
            "elasticloadbalancing.amazonaws.com",
            "spot.amazonaws.com",
            "spotfleet.amazonaws.com",
            "transitgateway.amazonaws.com"
          ]
        }
      }
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