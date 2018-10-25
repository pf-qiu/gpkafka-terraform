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

wait