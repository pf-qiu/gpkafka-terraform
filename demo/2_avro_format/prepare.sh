gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
dropdb testdb
createdb testdb
psql -c "create extension gpss" testdb
psql -c "create table demo2(a bigint, b text, c timestamp)" testdb
EOF

gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
kafka-topics --zookeeper localhost --delete --topic demo2
kafka-topics --zookeeper localhost --create --topic demo2 --partitions 1 --replication-factor 1
EOF

gcloud compute scp demo2.yml gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file ${GCLOUD_SSH_KEY}