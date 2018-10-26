gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
dropdb testdb
createdb testdb
psql -c "create table demo1(a text)" testdb
EOF

gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
kafka-topics --zookeeper localhost --delete --topic demo1
kafka-topics --zookeeper localhost --create --topic demo1 --partitions 8 --replication-factor 1

rm -f data
for ((i = 0; i < 1000000; i++))
do
echo "\$i" >> data
done
EOF

gcloud compute scp demo1.yml gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file ${GCLOUD_SSH_KEY}
