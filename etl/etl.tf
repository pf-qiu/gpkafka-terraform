resource "google_compute_instance" "etl" {
  name                      = "${var.name_prefix}etl"
  allow_stopping_for_update = "true"
  machine_type              = "${var.etl_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.etl_disk_image}"
      type  = "${var.etl_disk_type}"
      size  = "${var.etl_disk_size}"
    }
  }

  network_interface {
    subnetwork = "${var.subnet_name}"

    access_config {}
  }

  service_account {
    scopes = ["storage-ro"]
  }
}
