provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}
module "network" {
  source = "./network"
  name_prefix = "${var.name_prefix}"

  region = "${var.region}"
  region_zone = "${var.region_zone}"
}
module "gpdb" {
  source = "./gpdb"
  name_prefix = "${var.name_prefix}"
  subnet_name = "${module.network.subnet_name}"
}

module "kafka" {
  source = "./kafka"
  name_prefix = "${var.name_prefix}"
  subnet_name = "${module.network.subnet_name}"
}

module "etl" {
  source = "./etl"
  name_prefix = "${var.name_prefix}"
  subnet_name = "${module.network.subnet_name}"
}