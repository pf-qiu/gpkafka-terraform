#!/bin/bash
KAFKA_PER_HOST=${KAFKA_PER_HOST:-4}
gcloud compute scp kafka_setup_env.sh kafka_setup_remote.sh *.properties gpadmin@$NAME_PREFIX-kafka:~/ --ssh-key-file ${GCLOUD_SSH_KEY}
gcloud compute ssh gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
  export GOOGLE_CLOUD_BUCKET=$GOOGLE_CLOUD_BUCKET
  export KAFKA_PACKAGE=$KAFKA_PACKAGE
  ./kafka_setup_remote.sh $KAFKA_PER_HOST
EOF
