#!/bin/bash

if [ -f "env.sh" ]; then
    source env.sh
fi

CONFIG_VAR_FILE=env.sh

function input_config() {
    CONFIG_VAR=$1
    CONFIG_TEXT=${!2}
    DEFAULT_VALUE=$3
    if [ -z ${!CONFIG_VAR} ]; then
        echo "${CONFIG_TEXT}"
        if [ ! -z "${DEFAULT_VALUE}" ]; then
            read $CONFIG_VAR
            if [ -z "${!CONFIG_VAR}" ]; then
                echo "Using default value $DEFAULT_VALUE"
                eval "${CONFIG_VAR}=$DEFAULT_VALUE"
            fi
        else
            while [ -z ${!CONFIG_VAR} ]; do
                read $CONFIG_VAR
            done
        fi
        export ${CONFIG_VAR}
        echo "export $CONFIG_VAR=${!CONFIG_VAR}" >> ${CONFIG_VAR_FILE}
    fi
}

function config_name_prefix() {
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify name prefix of cloud resources.
Press enter to accept the default value: gpdb
EOF
input_config NAME_PREFIX CONFIG_TEXT gpdb
}

function config_num_seghosts() {
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify number of segment host.
Press enter to accept the default value: 2
EOF
input_config NUM_SEGHOSTS CONFIG_TEXT 2
}

function config_segment_per_host() {
read -r -d '' CONFIG_TEXT << EOF

*************************************************
Specify gpdb instance per segment host.
Press enter to accept the default value: 2
EOF
input_config SEGMENT_PER_HOST CONFIG_TEXT 2
}

function config_gcloud_secret() {
read -r -d '' CONFIG_TEXT << EOF

*************************************************
Specify google cloud secret json file.
Obtain this file from following location:
Console Home -> IAM & admin -> Service accounts
EOF
input_config GOOGLE_CLOUD_KEYFILE_JSON CONFIG_TEXT
}

function config_gcloud_bucket() {
read -r -d '' CONFIG_TEXT << EOF

*************************************************
Specify google cloud storage bucket.
EOF
input_config GOOGLE_CLOUD_BUCKET CONFIG_TEXT
}

function config_gpdb_rpm() {
    if [ -z "${GPDB_RPM}" ]; then
        RPMS=$(gsutil ls gs://${GOOGLE_CLOUD_BUCKET}/greenplum-db-*-rhel6-x86_64.rpm)
        if [ -z "${RPMS}" ]; then
            read -r -d '' CONFIG_TEXT << EOF
*************************************************
No rpm found in cloud bucket.
Specify location of gpdb RPM for RHEL 6 to upload.
Download it from pivotal network:
https://network.pivotal.io/products/pivotal-gpdb/
EOF
            input_config GPDB_RPM_LOCATION CONFIG_TEXT
            GPDB_RPM=$(basename -- "${GPDB_RPM_LOCATION}")
            export GPDB_RPM
            gsutil cp ${GPDB_RPM_LOCATION} gs://${GOOGLE_CLOUD_BUCKET}/${GPDB_RPM}
        else
            for RPM in $RPMS
            do
                export GPDB_RPM=$(basename -- "${RPM}")
            done
            echo "Using ${GPDB_RPM} in cloud bucket"
        fi
        echo "export GPDB_RPM=$GPDB_RPM" >> ${CONFIG_VAR_FILE}
    fi
}

function config_kafka_package() {
    if [ -z "${KAFKA_PACKAGE}" ]; then
        KAFKA_PACKAGES=$(gsutil ls gs://${GOOGLE_CLOUD_BUCKET}/confluent-oss-*.tar.gz)
        if [ -z "${KAFKA_PACKAGES}" ]; then
            read -r -d '' CONFIG_TEXT << EOF
*************************************************
No confluent kafka found in cloud bucket.
Specify location of confluent kafka oss to upload.
Download open source from confluent:
https://www.confluent.io/download/
EOF
            input_config KAFKA_PACKAGE_LOCATION CONFIG_TEXT
            KAFKA_PACKAGE=$(basename -- "${KAFKA_PACKAGE_LOCATION}")
            export KAFKA_PACKAGE
            gsutil cp ${KAFKA_PACKAGE_LOCATION} gs://${GOOGLE_CLOUD_BUCKET}/${KAFKA_PACKAGE}
        else
            for PACKAGE in ${KAFKA_PACKAGES}
            do
                export KAFKA_PACKAGE=$(basename -- "${PACKAGE}")
            done
            echo "Using ${KAFKA_PACKAGE} in cloud bucket"
        fi
        echo "export KAFKA_PACKAGE=$KAFKA_PACKAGE" >> ${CONFIG_VAR_FILE}
    fi

}

function config_gcloud_ssh_key() {
if [ -z "${GCLOUD_SSH_KEY}" ]; then
    cat << EOF
*************************************************
Specify google cloud ssh key.
Press enter to generate in current folder.
EOF
    read GCLOUD_SSH_KEY
    if [ -z "${GCLOUD_SSH_KEY}" ]; then
        GCLOUD_SSH_KEY=`pwd`/id_rsa
        if [ ! -f "${GCLOUD_SSH_KEY}" ]; then
            ssh-keygen -t rsa -N "" -f ${GCLOUD_SSH_KEY} 
        fi
    fi
    export GCLOUD_SSH_KEY
    echo "export GCLOUD_SSH_KEY=${GCLOUD_SSH_KEY}" >> ${CONFIG_VAR_FILE}
    PUBLIC_KEY=$(ssh-keygen -y -f ${GCLOUD_SSH_KEY})
fi
}

function config_kafka_per_host() {
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify number of kafka brokers per host.
Press enter to accept the default value: 4
EOF
input_config KAFKA_PER_HOST CONFIG_TEXT 4
}

function config_project() {
DEFAULT_PROJECT=$(gcloud config get-value project)
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify google project to use.
Press enter to accept the default value:
${DEFAULT_PROJECT}
EOF

input_config PROJECT CONFIG_TEXT ${DEFAULT_PROJECT}
}

function config_region() {
DEFAULT_REGION=$(gcloud config get-value compute/region)
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify google compute region to use.
Press enter to accept the default value:
${DEFAULT_REGION}
EOF

input_config REGION CONFIG_TEXT ${DEFAULT_REGION}
}

function config_zone() {
DEFAULT_ZONE=$(gcloud config get-value compute/zone)
read -r -d '' CONFIG_TEXT << EOF
*************************************************
Specify google compute region to use.
Press enter to accept the default value:
${DEFAULT_ZONE}
EOF

input_config ZONE CONFIG_TEXT ${DEFAULT_ZONE}
}


config_gcloud_secret
config_project
config_region
config_zone
config_name_prefix
config_gcloud_bucket
config_gpdb_rpm
config_gcloud_ssh_key
config_num_seghosts
config_segment_per_host
config_kafka_package
config_kafka_per_host

cd gpdb
./gen_seg_config.sh
cd ..

cat > variable.tf << EOF
variable "region" {
  default = "${REGION}"
}

variable "region_zone" {
  default = "${ZONE}"
}

variable "project" {
  default = "${PROJECT}"
}

variable "name_prefix" {
  default = "$NAME_PREFIX-"
}
EOF

cat << EOF
*************************************************
Configuration finished. Next:
source env.sh
terraform init
terraform apply
./setup.sh
EOF
