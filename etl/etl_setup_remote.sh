#!/bin/bash
set -e
gsutil cp gs://$GOOGLE_CLOUD_BUCKET/$GPDB_RPM .
sudo rpm -i $GPDB_RPM
echo "source /usr/local/greenplum-db/greenplum_path.sh" >> ~/.bashrc