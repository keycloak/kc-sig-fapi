#!/bin/sh

# ARG1: Alias of FAPI Conformance suite server config
# ARG2: Hostname of FAPI Conformance suite server
# ARG3: Hostname of Keycloak server
# ARG4: Hostname of Resource server
# ARG5: Realm name
# ARG6: Scope
FCSS_ALIAS=${1:-keycloak}
FCSS_HOST=${2-conformance-suite.keycloak-fapi.org}
KC_HOST=${3:-as.keycloak-fapi.org}
RS_HOST=${4:-rs.keycloak-fapi.org}
REALM=${5:-test}
SCOPE=${6:-openid}


DIR=$(cd $(dirname $0); pwd)
cd $DIR

./https/generate-server.sh $KC_HOST $RS_HOST
./https/generate-clients.sh
./client_private_keys/generate-keys.sh
./keycloak/generate-realm.sh $FCSS_HOST $FCSS_ALIAS $REALM
./fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh $KC_HOST $RS_HOST $FCSS_ALIAS $REALM $SCOPE

