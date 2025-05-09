resource "aws_launch_template" "launch_template" {
  name = "${var.uid}-launch-template"
  description = "${var.name} launch template"
  
  image_id = var.ami_id

  key_name = data.aws_key_pair.kp.key_name
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  instance_requirements {
    spot_max_price_percentage_over_lowest_price = var.spot_max_price_percent
    memory_mib {
      min = var.memory_mib
      max = var.memory_mib
    }
    vcpu_count {
      min = var.vcpu_count
      max = var.vcpu_count
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

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.uid}-root-volume"
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

resource "aws_iam_role" "role" {
  name = "${var.uid}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Sid       = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "policy" {
  name = "${var.uid}-policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:AttachVolume",
        "ec2:DetachVolume",
        "ec2:DescribeVolumes",
        "ec2:DescribeInstances",
        "ec2:AssociateAddress"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role        = aws_iam_role.role.name
  policy_arn  = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name  = "${var.uid}-instance-profile"
  role  = aws_iam_role.role.name
}