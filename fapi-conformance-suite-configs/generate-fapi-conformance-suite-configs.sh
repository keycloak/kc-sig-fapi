#!/bin/bash

# ARG1: Hostname of Keycloak server
# ARG2: Hostname of Resource server
# ARG3: Alias of FAPI Conformance suite server config
# ARG4: Realm name
# ARG5: Scope
KC_HOST=${1:-as.keycloak-fapi.org}
RS_HOST=${2:-rs.keycloak-fapi.org}
FCSS_ALIAS=${3:-keycloak}
REALM=${4:-test}
SCOPE=${5:-openid}

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
        "discoveryUrl": "https://$KC_HOST/auth/realms/$REALM/.well-known/openid-configuration"
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
        "resourceUrl": "https://$RS_HOST/",
        "institution_id": "xxx"
    },
    "browser": [
        {
            "match": "https://$KC_HOST/auth/realms/$REALM/openid-connect/auth*",
            "tasks": [
                {
                    "task": "Initial Login",
                    "match": "https://$KC_HOST/auth/realms/$REALM/openid-connect/auth*",
                    "commands": [
                        [
                            "text",
                            "name",
                            "username",
                            "john"
                        ],
                        [
                            "text",
                            "name",
                            "password",
                            "john"
                        ],
                        [
                            "click",
                            "name",
                            "login"
                        ]
                    ]
                },
                {
                    "task": "Verify Complete",
                    "match": "https://*/test/a/$FCSS_ALIAS/callback*",
                    "commands": [
                        [
                            "wait",
                            "id",
                            "submission_complete",
                            10
                        ]
                    ]
                }
            ]
        }
    ]
}
EOS
}

echo "Generating FAPI Conformance suite config json..."

generateConfigWithPrivateKey PS256 PS256 > fapi-rw-id2-with-private-key-PS256-PS256.json
generateConfigWithPrivateKey ES256 ES256 > fapi-rw-id2-with-private-key-ES256-ES256.json
generateConfigWithPrivateKey RS256 PS256 > fapi-rw-id2-with-private-key-RS256-PS256.json

