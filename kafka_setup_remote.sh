#!/bin/bash
set -exo
sudo ./kafka_env_setup.sh
gsutil cp gs://gpdb-test/confluent-oss-4.0.0-2.11.tar.gz .
tar -xf confluent-oss-4.0.0-2.11.tar.gz
export PATH=`pwd`/confluent-4.0.0/bin:$PATH

zookeeper-server-start -daemon zookeeper.properties

function start_kafka_node() {
    id=$1
    host=`hostname`
    port=$((9092+$id))
    config=server.properties.$id
    cp server.properties $config
    echo "broker.id=$id" >> $config
    echo "listeners=PLAINTEXT://$host:$port" >> $config
    echo "log.dirs=/data/kafka-logs-$id" >> $config
    kafka-server-start -daemon $config
}

for ((id=0; id<$1; id++))
do
    start_kafka_node $id
done

schema-registry-start -daemon schema-registry.properties