module "launch_template" {
  source = "../launch_template"
  
  ami_id = var.ami_id
  name = var.name
  uid = var.uid
  application = var.application
  availability_zone = var.availability_zone
  volume_size = var.volume_size
  user_data = var.user_data

  memory_mib = var.memory_mib
  vcpu_count = var.vcpu_count
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                = "${var.uid}-asg"
  availability_zones  = ["ap-southeast-2a"]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  force_delete        = false

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_capacity,
      launch_template[0].version
     ]
  }

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                   = var.od_base_capacity
      on_demand_percentage_above_base_capacity  = var.od_percent_above_base
      spot_allocation_strategy                  = "capacity-optimized"
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