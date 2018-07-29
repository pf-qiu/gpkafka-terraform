provider "google" {
  project = "data-gpdb-unite-gpdb-clients"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}

resource "google_compute_network" "gpdb_net" {
  name                    = "gpdb-net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gpdb_subnet" {
  name          = "gpdb-net"
  ip_cidr_range = "10.20.0.0/16"
  network       = "${google_compute_network.gpdb_net.self_link}"
  region        = "${var.region}"
}

resource "google_compute_firewall" "allow-all-internal" {
  name    = "allow-all-gpdb-net"
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
  name    = "allow-ssh-gpdb-net"
  network = "${google_compute_network.gpdb_net.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }
}
