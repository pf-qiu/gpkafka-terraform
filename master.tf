resource "google_compute_instance" "mdw" {
  name         = "mdw"
  allow_stopping_for_update = "true"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-6"
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
