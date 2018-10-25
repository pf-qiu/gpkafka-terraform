gcloud compute ssh gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
dropdb testdb
createdb testdb
psql -c "create table test(a text)" testdb
EOF

gcloud compute ssh gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
kafka-topics --zookeeper localhost --delete --topic demo1
kafka-topics --zookeeper localhost --create --topic demo1 --partitions 1 --replication-factor 1
EOF

gcloud compute scp simple_load.yml gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file ${GCLOUD_SSH_KEY}

cat <<-EOF
On gpdb-kafka:
kafka-console-producer --broker-list gpdb-kafka:9092 --topic demo1

On gpdb-etl:
gpkafka load simple_load.yml

On gpdb-mdw:
psql testdb
select count(*) from test
EOF
