module "launch_template" {
  source = "../launch_template"
  
  ami_id = var.ami_id
  name = var.name
  application = var.application
  availability_zone = var.availability_zone
  volume_size = var.volume_size
  user_data = var.user_data
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                = "${var.name}-asg-${module.launch_template.launch_template_version}"
  availability_zones  = ["ap-southeast-2a"]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                   = var.od_base_capacity
      on_demand_percentage_above_base_capacity  = var.od_percent_above_base
      spot_allocation_strategy                  = "price-capacity-optimized"
      spot_max_price = var.spot_price
    }

    launch_template {
      launch_template_specification {
        version = "$Latest"
        launch_template_id = module.launch_template.launch_template_id
      }
    }
  }
}

resource "aws_autoscaling_lifecycle_hook" "detach_ebs_hook" {
  name                    = "detach-ebs"
  autoscaling_group_name  = aws_autoscaling_group.autoscaling_group.name
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
  heartbeat_timeout       = 300
  default_result          = "CONTINUE"
}