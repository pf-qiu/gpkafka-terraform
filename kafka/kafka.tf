resource "google_compute_instance" "kafka" {
  name                      = "${var.name_prefix}kafka"
  allow_stopping_for_update = "true"
  machine_type              = "${var.kafka_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.kafka_disk_image}"
      type  = "${var.kafka_disk_type}"
      size  = "${var.kafka_disk_size}"
    }
  }

  network_interface {
    subnetwork = "${var.subnet_name}"

    access_config {}
  }

  scratch_disk {
      interface = "NVME"
  }

  service_account {
    scopes = ["storage-ro"]
  }
}
