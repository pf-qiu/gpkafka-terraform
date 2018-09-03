#!/bin/bash
set -e
gsutil cp gs://gpdb-test/* .
mkdir greenplum-db-devel
tar -xf bin_gpdb.tar.gz -C greenplum-db-devel
tar -xf gpss_component.tar.gz -C greenplum-db-devel
sed -i -e "s/^GPHOME=.*/GPHOME=\/home\/gpadmin\/greenplum-db-devel/g" greenplum-db-devel/greenplum_path.sh
source greenplum-db-devel/greenplum_path.sh

gpssh-exkeys -f hosts_all
gpseginstall -f hosts_all

gpscp -f hosts_segs gpdb_setup_env.sh =:/home/gpadmin/
echo "sudo gpdb_setup_env.sh" | gpssh -f hosts_segs

mkdir -p $MASTER_BASE_DIR
echo "mkdir -p $SEGMENT_BASE_DIR" | gpssh -f hosts_segs
gpinitsystem -a -c init_config -h hosts_segs
