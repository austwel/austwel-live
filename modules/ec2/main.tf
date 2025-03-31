resource "aws_instance" "instance" {
  count = (var.spot_instance ? 0 : 1)

  # Instance
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone

  # Volume
  root_block_device {
    volume_type               = var.root_volume_type
    delete_on_termination     = true
    volume_size               = var.root_volume_size
    tags                      = var.volume_tags
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices

    content {
      device_name             = ebs_block_device.value["device_name"]
      volume_type             = lookup(ebs_block_device.value, "type", "")
      delete_on_termination   = lookup(ebs_block_device.value, "delete_on_termination", true)
      volume_size             = lookup(ebs_block_device.value, "size", 8)
      tags                    = var.volume_tags
    }
  }

  tags = var.instance_tags
}

resource "aws_spot_instance_request" "instance_spot" {
  count = (var.spot_instance ? 1 : 0)
  
  # Spot
  spot_price                  = var.spot_price
  wait_for_fulfillment        = true

  # Instance
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone

  # Volume
  root_block_device {
    volume_type               = var.root_volume_type
    delete_on_termination     = true
    volume_size               = var.root_volume_size
    tags                      = var.volume_tags
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices

    content {
      device_name             = ebs_block_device.value["device_name"]
      volume_type             = lookup(ebs_block_device.value, "type", "")
      delete_on_termination   = lookup(ebs_block_device.value, "delete_on_termination", true)
      volume_size             = lookup(ebs_block_device.value, "size", 8)
      tags                    = var.volume_tags
    }
  }

  tags = var.instance_tags
}

resource "aws_ebs_volume" "ebs_volume" {
  count                       = length(var.volumes)

  size                        = element(var.volumes, count.index).size
  type                        = element(var.volumes, count.index).type
  availability_zone           = var.availability_zone

  tags                        = var.volume_tags
}

resource "aws_volume_attachment" "volume_attachment" {
  count = length(var.volumes) * (var.spot_instance ? 0 : 1)

  force_detach = true

  device_name = element(var.volumes, count.index).device_name
  volume_id   = aws_ebs_volume.ebs_volume[count.index].id
  instance_id = aws_instance.instance[floor(count.index / length(var.volumes))].id
}

resource "aws_volume_attachment" "volume_attachment_spot" {
  count = length(var.volumes) * (var.spot_instance ? 1 : 0)

  force_detach = true

  device_name = element(var.volumes, count.index).device_name
  volume_id   = aws_ebs_volume.ebs_volume[count.index].id
  instance_id = aws_spot_instance_request.instance_spot[floor(count.index / length(var.volumes))].id
}
