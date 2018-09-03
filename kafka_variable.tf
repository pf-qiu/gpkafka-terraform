
variable "kafka_machine_type" {
  default = "n1-standard-2"
}

variable "kafka_disk_image" {
  default = "centos-cloud/centos-6"
}

variable "kafka_disk_type" {
  default = "pd-ssd"
}

variable "kafka_disk_size" {
  default = "40"
}
