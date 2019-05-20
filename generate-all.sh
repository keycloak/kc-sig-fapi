#!/bin/sh

# ARG1: Alias of FAPI Conformance suite server config
# ARG2: Hostname:port of FAPI Conformance suite server
# ARG3: Hostname:port of Keycloak server
# ARG4: Hostname:port of Resource server
# ARG5: Realm name
# ARG6: Scope
FCSS_ALIAS=${1:-keycloak}
FCSS_HOST_PORT=${2-localhost:8443}
KC_HOST_PORT=${3:-keycloak-fapi.org:9443}
RS_HOST_PORT=${4:-keycloak-fapi.org:10443}
REALM=${5:-test}
SCOPE=${6:-openid}


DIR=$(cd $(dirname $0); pwd)
cd $DIR

KC_HOST=`echo $KC_HOST_PORT | cut -d":" -f 1`
RS_HOST=`echo $RS_HOST_PORT | cut -d":" -f 1`

./https/generate-self-signed-certificates.sh $KC_HOST $RS_HOST
./client_private_keys/generate-keys.sh
./realm/generate-realm.sh $FCSS_ALIAS $FCSS_HOST_PORT $REALM
./fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh $FCSS_ALIAS $KC_HOST_PORT $RS_HOST_PORT $REALM $SCOPE

