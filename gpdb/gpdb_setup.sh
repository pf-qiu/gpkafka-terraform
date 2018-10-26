set -e
MASTER_BASE_DIR=/home/gpadmin/data/master
SEGMENT_BASE_DIR=/data/primary
SEGMENT_BASE_DIRS=" "
SEGMENT_PER_HOST=${SEGMENT_PER_HOST:-2}

for ((i=0; i<$SEGMENT_PER_HOST; i++))
do
SEGMENT_BASE_DIRS=" $SEGMENT_BASE_DIR$SEGMENT_BASE_DIRS"
done

cat > init_config <<-EOF
ARRAY_NAME="Greenplum Data Platform"
declare -a DATA_DIRECTORY=($SEGMENT_BASE_DIRS)
SEG_PREFIX=gpseg
PORT_BASE=6000
MASTER_HOSTNAME=$NAME_PREFIX-mdw
MASTER_PORT=5432
MASTER_DIRECTORY=$MASTER_BASE_DIR
TRUSTED_SHELL=ssh
ENCODING=UNICODE

EOF

gcloud compute scp ${GCLOUD_SSH_KEY} ${GCLOUD_SSH_KEY}.pub gpadmin@$NAME_PREFIX-mdw:~/.ssh/ --ssh-key-file ${GCLOUD_SSH_KEY}
gcloud compute scp gpdb_setup_remote.sh gpdb_setup_env.sh init_config hosts_all hosts_segs gpadmin@$NAME_PREFIX-mdw:~/ --ssh-key-file ${GCLOUD_SSH_KEY}
gcloud compute ssh gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
  export MASTER_BASE_DIR=$MASTER_BASE_DIR
  export SEGMENT_BASE_DIR=$SEGMENT_BASE_DIR
  export GOOGLE_CLOUD_BUCKET=${GOOGLE_CLOUD_BUCKET}
  export GPDB_RPM=${GPDB_RPM}
  ./gpdb_setup_remote.sh
EOF