#!/bin/bash
KAFKA_PER_HOST=${KAFKA_PER_HOST:-8}
gcloud compute scp kafka_setup_env.sh kafka_setup_remote.sh *.properties gpadmin@$NAME_PREFIX-kafka:~/ --ssh-key-file id_rsa
gcloud compute ssh gpadmin@$NAME_PREFIX-kafka --ssh-key-file id_rsa <<-EOF
  ./kafka_setup_remote.sh $KAFKA_PER_HOST
EOF
