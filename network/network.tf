resource "google_compute_network" "gpdb_net" {
  name                    = "${var.name_prefix}net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gpdb_subnet" {
  name          = "${var.name_prefix}subnet"
  ip_cidr_range = "10.20.0.0/16"
  network       = "${google_compute_network.gpdb_net.self_link}"
  region        = "${var.region}"
}

resource "google_compute_firewall" "allow-all-internal" {
  name    = "allow-all-${google_compute_network.gpdb_net.name}"
  network = "${google_compute_network.gpdb_net.name}"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${google_compute_subnetwork.gpdb_subnet.ip_cidr_range}"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh-${google_compute_network.gpdb_net.name}"
  network = "${google_compute_network.gpdb_net.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }
}

output "subnet_name" {
  value = "${google_compute_subnetwork.gpdb_subnet.name}"
}