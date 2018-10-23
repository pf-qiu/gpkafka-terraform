#!/bin/bash
gcloud compute scp ${GCLOUD_SSH_KEY} ${GCLOUD_SSH_KEY}.pub gpadmin@$NAME_PREFIX-etl:~/.ssh/ --ssh-key-file ${GCLOUD_SSH_KEY}
gcloud compute scp etl_setup_remote.sh gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file ${GCLOUD_SSH_KEY}
gcloud compute ssh gpadmin@$NAME_PREFIX-etl --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
  export GOOGLE_CLOUD_BUCKET=${GOOGLE_CLOUD_BUCKET}
  export GPDB_RPM=${GPDB_RPM}
  ./etl_setup_remote.sh
EOF
