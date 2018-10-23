
variable "etl_machine_type" {
  default = "n1-highcpu-8"
}

variable "etl_disk_image" {
  default = "centos-cloud/centos-6"
}

variable "etl_disk_type" {
  default = "pd-ssd"
}

variable "etl_disk_size" {
  default = "40"
}
