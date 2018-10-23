
variable "master_machine_type" {
  default = "n1-standard-4"
}

variable "master_disk_image" {
  default = "centos-cloud/centos-6"
}

variable "master_disk_type" {
  default = "pd-ssd"
}

variable "master_disk_size" {
  default = "40"
}
