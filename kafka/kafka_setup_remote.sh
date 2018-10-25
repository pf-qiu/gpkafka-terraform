#!/bin/bash
set -exo
sudo ./kafka_setup_env.sh
gsutil cp gs://${GOOGLE_CLOUD_BUCKET}/${KAFKA_PACKAGE} .
tar -xf ${KAFKA_PACKAGE}
KAFKA_DIR=$(ls -d confluent-*/)
KAFKA_FULL_DIR=`pwd`/${KAFKA_DIR}/bin
echo "export PATH=${KAFKA_FULL_DIR}:$PATH" >> ~/.profile
source ~/.profile

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