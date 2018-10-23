if [ ! -f "env.sh" ]; then
    echo "run configure.sh first"
    exit 1
fi
source env.sh

pushd gpdb
./gpdb_setup.sh
popd

pushd kafka
./kafka_setup.sh
popd

pushd etl
./etl_setup.sh
popd