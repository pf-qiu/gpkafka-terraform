#!/bin/bash
set -e
gsutil cp gs://$GOOGLE_CLOUD_BUCKET/$GPDB_RPM .
sudo rpm -i $GPDB_RPM
source /usr/local/greenplum-db/greenplum_path.sh

echo "Install rpm on all segments"
gpscp -f hosts_segs gpdb_setup_env.sh $GPDB_RPM =:/home/gpadmin/
echo "sudo ./gpdb_setup_env.sh" | gpssh -f hosts_segs
gpssh-exkeys -f hosts_all

echo "Setup gpdb cluster"
mkdir -p $MASTER_BASE_DIR
echo "mkdir -p $SEGMENT_BASE_DIR" | gpssh -f hosts_segs
gpinitsystem -a -c init_config -h hosts_segs
