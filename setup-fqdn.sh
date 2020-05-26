#!/bin/sh

# ARG1: Hostname of FAPI Conformance suite server
# ARG2: Hostname of Keycloak server
# ARG3: Hostname of Resource server
CONFORMANCE_SUITE_FQDN=${1:-conformance-suite.keycloak-fapi.org}
KEYCLOAK_FQDN=${2:-as.keycloak-fapi.org}
RESOURCE_FQDN=${3:-rs.keycloak-fapi.org}

DIR=$(cd $(dirname $0); pwd)
cd $DIR

./https/generate-server.sh $KEYCLOAK_FQDN $RESOURCE_FQDN
./keycloak/generate-realm.sh $CONFORMANCE_SUITE_FQDN
./fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh $KEYCLOAK_FQDN $RESOURCE_FQDN

