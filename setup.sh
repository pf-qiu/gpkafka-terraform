if [ ! -f "env.sh" ]; then
    echo "run configure.sh first"
    exit 1
fi
source env.sh

pushd gpdb
./gpdb_setup.sh >gpdb_setup.log 2>gpdb_setup.err &
popd

pushd kafka
./kafka_setup.sh >kafka_setup.log 2>kafka_setup.err &
popd

pushd etl
./etl_setup.sh >etl_setup.log 2>etl_setup.err &
popd

wait $(jobs -p)

gcloud compute ssh gpadmin@$NAME_PREFIX-mdw --ssh-key-file ${GCLOUD_SSH_KEY} <<-EOF
source ~/.bashrc
sed -i -e "s/10.20.0..\/32/10.20.0.0\/24/g" \${MASTER_DATA_DIRECTORY}/pg_hba.conf
gpstop -u
EOF
