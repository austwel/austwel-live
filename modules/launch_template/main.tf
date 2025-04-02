resource "aws_launch_template" "launch_template" {
  name = var.application
  description = "${var.application} launch template"

  block_device_mappings {
    device_name = "/dev/sdb"

    ebs {
      volume_size = var.volume_size
    }
  }

  image_id = var.ami_id

  instance_requirements {
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
      Name = var.application
    }
  }

  user_data = var.user_data
}

data "aws_ec2_spot_price" "current_spot_price" {
  for_each = var.instance_types
  instance_type = each.key
  availability_zone = var.availability_zone
  
  filter {
    name = "product-description"
    values = ["Linux/UNIX"]
  }
}