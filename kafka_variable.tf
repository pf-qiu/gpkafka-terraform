
variable "kafka_machine_type" {
  default = "n1-standard-8"
}

variable "kafka_disk_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "kafka_disk_type" {
  default = "pd-ssd"
}

variable "kafka_disk_size" {
  default = "40"
}
