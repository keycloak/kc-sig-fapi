#!/bin/sh

DIR=$(cd $(dirname $0); pwd)
cd $DIR

./https/generate-self-signed-certificates.sh
./client_private_keys/generate-keys.sh
./realm/generate-realm.sh
./fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh

