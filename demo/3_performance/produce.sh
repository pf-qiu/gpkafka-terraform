gcloud compute ssh --ssh-flag="-T" gpadmin@$NAME_PREFIX-kafka --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
for ((i = 0; i < 20; i++))
do
echo \$i
kafka-console-producer --broker-list $NAME_PREFIX-kafka:9092 --topic demo3 < data > /dev/null
done
EOF
