resource "aws_launch_template" "launch_template" {
  name_prefix   = var.application
  image_id      = var.ami_id
  instance_type = "r6a.large"
}

module "launch_template" {
  source = "../launch_template"
  
  ami_id = var.ami_id
  application = var.application
  availability_zone = var.availability_zone
  volume_size = var.volume_size
  user_data = var.user_data
}

resource "aws_autoscaling_group" "autoscaling_group" {
  availability_zones  = ["ap-southeast-2a"]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                   = var.od_base_capacity
      on_demand_percentage_above_base_capacity  = var.od_percent_above_base
      spot_allocation_strategy                  = "price-capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
      }

      override {
        instance_type     = "r6i.large"
        weighted_capacity = "3"
      }

      override {
        instance_type     = "r5n.large"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "r5a.large"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "r5.large"
        weighted_capacity = "2"
      }
    }
  }
}
