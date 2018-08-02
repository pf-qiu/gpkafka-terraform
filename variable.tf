variable "region" {
  default = "us-west1"
}

variable "region_zone" {
  default = "us-west1-a"
}

variable "segment_machine_type" {
  default = "n1-highcpu-2"
}

variable "segment_disk_image" {
  default = "centos-cloud/centos-6"
}

variable "segment_disk_type" {
  default = "pd-ssd"
}

variable "segment_disk_size" {
  default = "40"
}
