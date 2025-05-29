module "asg" {
  source = "../asg"

  ami_id                = can(regex("^[a-z0-9]+g[a-z0-9]*\\..*", var.instance_type)) ? "ami-0de8a897ddf3e8a40" : "ami-056c5f56210baa04a"
  application           = var.application
  name                  = var.name
  uid                   = var.uid

  wait_for_capacity_timeout = "10m"
  desired_capacity      = var.desired_capacity
  max_size              = 2
  min_size              = 0

  health_check_grace_period = 60

  od_base_capacity      = var.spot_instance ? 0 : 1
  od_percent_above_base = 0
  spot_price            = var.spot_price

  volume_size           = var.root_volume_size

  instance_type         = var.instance_type 

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tmpl", {
    ebs_volume_id       = module.volume.ebs_volume.id
    aws_region          = var.aws_region
    device_name         = var.ebs_volume.device_name
    mountpoint          = var.ebs_volume.mountpoint
    elastic_ip          = length(aws_eip.elastic_ip) > 0 ? aws_eip.elastic_ip[0].public_ip : ""
    modpack             = var.modpack
    cf_api_key          = trimspace(file("${path.module}/.curseforge_api_key"))
    name                = var.name
    server_memory       = var.server_memory == null ? ((data.aws_ec2_instance_type.instance_info.memory_size/1024)*6/8) : var.server_memory
    modpack_zip         = var.modpack_zip
    additional_envs     = var.additional_envs
    java_version        = var.java_version
    jvm_opts            = var.jvm_opts.jvm_opts
    jvm_xx_opts         = var.jvm_opts.jvm_xx_opts
    jvm_dd_opts         = var.jvm_opts.jvm_dd_opts
  }))
}

data "aws_ec2_instance_type" "instance_info" {
  instance_type = var.instance_type
}

resource "aws_autoscaling_schedule" "scale_up" {
  count = var.schedule == null || var.desired_capacity == 0 ? 0 : var.schedule.scale_up == null ? 0 : 1

  scheduled_action_name   = "scale_up"
  min_size                = 0
  max_size                = 2
  desired_capacity        = 1
  recurrence              = var.schedule.scale_up
  autoscaling_group_name  = module.asg.asg_name
  time_zone               = "Australia/Brisbane"
}

resource "aws_autoscaling_schedule" "scale_down" {
  count = var.schedule == null || var.desired_capacity == 0 ? 0 : var.schedule.scale_down == null ? 0 : 1

  scheduled_action_name   = "scale_down"
  min_size                = 0
  max_size                = 2
  desired_capacity        = 0
  recurrence              = var.schedule.scale_down
  autoscaling_group_name  = module.asg.asg_name
  time_zone               = "Australia/Brisbane"
}

module "volume" {
  source = "../ebs"

  volume_size = var.ebs_volume.size
  volume_type = var.ebs_volume.type

  tags = {
    "application" = "Minecraft Server Volume"
    "modpack"     = var.modpack
    "Name"        = "${var.uid}-data"
    "Snapshot"    = "${var.uid}-data"
  }
}

module "snapshots" {
  source = "../dlm"

  state               = var.desired_capacity > 0 ? "ENABLED" : "DISABLED"
  volume_name         = module.volume.volume_name
  snapshot_frequency  = 1
  snapshot_days       = 7
}

resource "aws_eip" "elastic_ip" {
  count   = var.desired_capacity > 0 ? 1 : 0
  domain  = "vpc"

  tags = {
    "application" = "Minecraft Server Elastic IP"
    "modpack"     = var.modpack
    "Name"        = "${var.uid}-eip"
  }
}