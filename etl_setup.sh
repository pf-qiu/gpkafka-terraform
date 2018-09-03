#!/bin/bash
gcloud compute scp etl_setup_remote.sh gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file id_rsa
gcloud compute ssh gpadmin@$NAME_PREFIX-etl --ssh-key-file id_rsa <<-EOF
  ./etl_setup_remote.sh
EOF
