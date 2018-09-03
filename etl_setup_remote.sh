set -e
gsutil cp gs://gpdb-test/gpss_component.tar.gz .
mkdir gpss
sudo tar -xf gpss_component.tar.gz -C /usr/local