gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-etl --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
gsutil cp gs://$GOOGLE_CLOUD_BUCKET/avro-producer .
chmod u+x avro-producer
./avro-producer http://$NAME_PREFIX-kafka:8081 10000 $NAME_PREFIX-kafka:9092 demo2
EOF
