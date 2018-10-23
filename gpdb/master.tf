resource "google_compute_instance" "mdw" {
  name                      = "${var.name_prefix}mdw"
  allow_stopping_for_update = "true"
  machine_type              = "${var.master_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.master_disk_image}"
      type  = "${var.master_disk_type}"
      size  = "${var.master_disk_size}"
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
