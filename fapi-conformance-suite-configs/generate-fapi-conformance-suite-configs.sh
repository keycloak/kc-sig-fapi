#!/bin/bash

# ARG1: Realm name
# ARG2: Hostname:port of FAPI Conformance suite server
# ARG3: Hostname:port of Resource server
REALM=${1:-test}
KC_HOST_PORT=${2:-keycloak-fapi.org:9443}
RS_HOST_PORT=${3:-rs.keycloak-fapi.org:10443}


SCOPE="openid"
FCSS_ALIAS=keycloak

DIR=$(cd $(dirname $0); pwd)
cd $DIR

########################################
# Generate FAPI Conformance suite config for Private Key function
#
# ARG1: Request object signature alg and private_key_jwt alg
# ARG2: ID/Access Token signature alg
########################################
generateConfigWithPrivateKey() {
    ROS_ALG=$1
    TOKEN_ALG=$2

    CLIENT1_JWKS=`cat ../client_private_keys/jwks_sig_${ROS_ALG}_client1-${ROS_ALG}.json`
    CLIENT2_JWKS=`cat ../client_private_keys/jwks_sig_${ROS_ALG}_client2-${ROS_ALG}.json`
    CLIENT1_MTLS_CERT=`cat ../https/client1.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT1_MTLS_KEY=`cat ../https/client1-key.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT2_MTLS_CERT=`cat ../https/client2.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT2_MTLS_KEY=`cat ../https/client2-key.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`

    cat << EOS
{
    "alias": "$FCSS_ALIAS",
    "description": "conformance suite using Keycloak FAPI-RW with private_key",
    "server": {
        "discoveryUrl": "https://$KC_HOST_PORT/auth/realms/$REALM/.well-known/openid-configuration"
    },
    "client": {
        "client_id": "client1-private_key_jwt-${ROS_ALG}-$TOKEN_ALG",
        "scope": "$SCOPE",
        "jwks": $CLIENT1_JWKS 
    },
    "client2": {
        "client_id": "client2-private_key_jwt-${ROS_ALG}-${TOKEN_ALG}",
        "scope": "$SCOPE",
        "jwks": $CLIENT2_JWKS 
    },
    "mtls": {
        "cert": "$CLIENT1_MTLS_CERT",
        "key": "$CLIENT1_MTLS_KEY"
    },
    "mtls2": {
        "cert": "$CLIENT2_MTLS_CERT",
        "key": "$CLIENT2_MTLS_KEY"
    },
    "resource": {
        "resourceUrl": "https://$RS_HOST_PORT/",
        "institution_id": "xxx"
    }
}
EOS
}

echo "Generating FAPI Conformance suite config json..."

generateConfigWithPrivateKey PS256 PS256 > fapi-rw-id2-with-private-key-PS256-PS256.json
generateConfigWithPrivateKey ES256 ES256 > fapi-rw-id2-with-private-key-ES256-ES256.json
generateConfigWithPrivateKey RS256 PS256 > fapi-rw-id2-with-private-key-RS256-PS256.json

