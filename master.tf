resource "google_compute_instance" "mdw" {
  name                      = "${var.name_prefix}mdw"
  allow_stopping_for_update = "true"
  machine_type              = "${var.segment_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.segment_disk_image}"
      type  = "${var.segment_disk_type}"
      size  = "${var.segment_disk_size}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.gpdb_subnet.name}"

    access_config {}
  }

  service_account {
    scopes = ["storage-ro"]
  }
}
