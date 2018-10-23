#!/bin/bash
rm -f segments.tf
rm -f hosts_all
rm -f hosts_segs

NUM_SEGHOSTS=${NUM_SEGHOSTS:-1}
for (( id=0; id<$NUM_SEGHOSTS; id++))
do

echo $NAME_PREFIX-sdw$id >> hosts_all
echo $NAME_PREFIX-sdw$id >> hosts_segs

cat >> segments.tf <<-EOF
resource "google_compute_instance" "sdw$id" {
  name         = "\${var.name_prefix}sdw$id"
  machine_type = "\${var.segment_machine_type}"

  boot_disk {
    initialize_params {
      image = "\${var.segment_disk_image}"
      type  = "\${var.segment_disk_type}"
      size  = "\${var.segment_disk_size}"
    }
  }

  network_interface {
    subnetwork = "\${var.subnet_name}"
  }
}
EOF
done
