variable "volume_name" {
  type = string
  description = "Name of the EBS Volume"
}

variable "snapshot_frequency" {
  type = number
  description = "How many hours between snapshots"
  default = 1
}

variable "snapshot_days" {
  type = number
  description = "How many days of snapshots to keep"
  default = 7
}

variable "state" {
  type = string
  description = "Enable or Disable DLM policy"
  default = "DISABLED"
}