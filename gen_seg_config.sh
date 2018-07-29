#!/bin/bash
rm -f seg*.tf
rm -f hosts_all
rm -f hosts_segs
echo mdw > hosts_all

NUM_SEGHOSTS=${NUM_SEGHOSTS:-1}
for (( id=0; id<$NUM_SEGHOSTS; id++))
do

echo sdw$id >> hosts_all
echo sdw$id >> hosts_segs

cat > seg$id.tf <<-EOF
resource "google_compute_instance" "sdw$id" {
  name         = "sdw$id"
  machine_type = "\${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-6"
    }
  }

  network_interface {
    subnetwork = "\${google_compute_subnetwork.gpdb_subnet.name}"
  }
}
EOF
done
