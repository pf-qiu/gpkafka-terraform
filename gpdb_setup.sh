set -e
MASTER_BASE_DIR=/home/gpadmin/data/master
SEGMENT_BASE_DIR=/home/gpadmin/data/primary
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

gcloud compute scp id_rsa id_rsa.pub gpadmin@$NAME_PREFIX-mdw:~/.ssh/ --ssh-key-file id_rsa
gcloud compute scp gpdb_setup_remote.sh init_config hosts_all hosts_segs gpadmin@$NAME_PREFIX-mdw:~/ --ssh-key-file id_rsa
gcloud compute ssh gpadmin@$NAME_PREFIX-mdw --ssh-key-file id_rsa <<-EOF
  export MASTER_BASE_DIR=$MASTER_BASE_DIR
  export SEGMENT_BASE_DIR=$SEGMENT_BASE_DIR
  ./gpdb_setup_remote.sh
EOF
