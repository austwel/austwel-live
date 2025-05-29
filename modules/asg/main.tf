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
  instance_type  = var.instance_type
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

  health_check_grace_period = var.health_check_grace_period

  launch_template {
    version = "$Latest"
    id = module.launch_template.launch_template_id
  }
}