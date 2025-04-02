resource "aws_ebs_volume" "ebs_volume" {
  size              = var.volume_size
  type              = var.volume_type
  availability_zone = var.availability_zone

  tags = var.tags
}
