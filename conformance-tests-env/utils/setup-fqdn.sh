#!/bin/sh

# ARG1: Hostname of FAPI Conformance suite server
# ARG2: Hostname of Keycloak server
# ARG3: Hostname of Resource server
# ARG4: Hostname of Consent server (FAPI-BR)
# ARG5: Hostname of Authentication Entity server (FAPI-CIBA)
CONFORMANCE_SUITE_FQDN=${1:-conformance-suite.keycloak-fapi.org}
KEYCLOAK_FQDN=${2:-as.keycloak-fapi.org}
RESOURCE_FQDN=${3:-rs.keycloak-fapi.org}
CONSENT_FQDN=${4:-cs.keycloak-fapi.org}
AUTH_ENTITY_FQDN=${5:-aes.keycloak-fapi.org}

DIR=$(cd $(dirname $0); pwd)
cd $DIR

../common/https/generate-server.sh $KEYCLOAK_FQDN $RESOURCE_FQDN $CONSENT_FQDN $AUTH_ENTITY_FQDN
../test-target/keycloak/keycloak/generate-realm.sh $CONFORMANCE_SUITE_FQDN
../conformance-suite/fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh $KEYCLOAK_FQDN $RESOURCE_FQDN

