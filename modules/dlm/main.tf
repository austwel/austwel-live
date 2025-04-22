resource "aws_dlm_lifecycle_policy" "ebs_snapshots" {
  description         = "EBS snapshot policy for ${var.volume_name}"
  execution_role_arn  = data.aws_iam_role.dlm.arn
  state               = var.state

  policy_details {
    policy_type     = "EBS_SNAPSHOT_MANAGEMENT"
    resource_types  = ["VOLUME"]

    target_tags = {
      Snapshot = var.volume_name
    }

    schedule {
      name = "${var.volume_name}-snapshots"

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      create_rule {
        interval      = var.snapshot_frequency
        interval_unit = "HOURS"
        times         = ["00:00"]
      }

      retain_rule {
        count = var.snapshot_days * (24 / var.snapshot_frequency)
      }
    }
  }
}

data "aws_iam_role" "dlm" {
  name = "AWSDataLifecycleManagerDefaultRole"
}