resource "aws_launch_template" "launch_template" {
  name = var.application
  description = "${var.name} launch template"
  
  image_id = var.ami_id

  key_name = data.aws_key_pair.kp.key_name
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  instance_requirements {
    #spot_max_price_percentage_over_lowest_price = var.spot_max_price_percent
    allowed_instance_types = var.instance_types
    memory_mib {
      min = 16384
      max = 16384
    }
    vcpu_count {
      min = 2
      max = 2
    }
  }

  monitoring {
    enabled = false
  }

  placement {
    availability_zone = var.availability_zone
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name
    }
  }

  user_data = var.user_data
}

data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = ["launch-wizard-1"]
  }
}

data "aws_key_pair" "kp" {
  key_name = "default"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.application}-instanceprofile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "${var.application}-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:AssociateAddress",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RunInstances"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateTags"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "ec2:CreateAction": "RunInstances"
          }
        }
      }
    ]
  })

  tags = {
    application = var.application
  }
}
