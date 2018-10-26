gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
dropdb testdb
createdb testdb
psql -c "create table demo3(a int, b text)" testdb
EOF

gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
kafka-topics --zookeeper localhost --delete --topic demo3
kafka-topics --zookeeper localhost --create --topic demo3 --partitions 16 --replication-factor 1

rm -f data
for ((i = 0; i < 1000000; i++))
do
echo "\$i,abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz" >> data
done
EOF

gcloud compute scp demo3.yml gpadmin@$NAME_PREFIX-etl:~/ --ssh-key-file ${GCLOUD_SSH_KEY}
