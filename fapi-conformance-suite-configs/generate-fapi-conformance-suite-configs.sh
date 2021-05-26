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
SCOPE=${5:-openid email}

DIR=$(cd $(dirname $0); pwd)
cd $DIR

########################################
# Generate FAPI Conformance suite config for Private Key function
#
# ARG1: Client authentication type (mtls or private_key_jwt)
# ARG2: Request object signature alg and private_key_jwt alg
# ARG3: ID/Access Token signature alg
########################################
generateConfig() {
    CLIENT_AUTH_TYPE=$1
    ROS_ALG=$2
    TOKEN_ALG=$3

    CLIENT1_JWKS=`cat ../client_private_keys/jwks_sig_${ROS_ALG}_client1-${ROS_ALG}.json`
    CLIENT2_JWKS=`cat ../client_private_keys/jwks_sig_${ROS_ALG}_client2-${ROS_ALG}.json`
    CLIENT1_MTLS_CERT=`cat ../https/client1.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT1_MTLS_KEY=`cat ../https/client1-key.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT2_MTLS_CERT=`cat ../https/client2.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`
    CLIENT2_MTLS_KEY=`cat ../https/client2-key.pem | awk 'BEGIN{ORS = "\\\\n"}{print $0}'`

    cat << EOS
{
    "alias": "$FCSS_ALIAS",
    "description": "FAPI1-Advanced-Final: Keycloak test with ${CLIENT_AUTH_TYPE} client authentication (RequestObject:${ROS_ALG}/IDToken:${TOKEN_ALG})",
    "server": {
        "discoveryUrl": "https://$KC_HOST/auth/realms/$REALM/.well-known/openid-configuration"
    },
    "client": {
        "client_id": "client1-${CLIENT_AUTH_TYPE}-${ROS_ALG}-${TOKEN_ALG}",
        "scope": "$SCOPE",
        "jwks": $CLIENT1_JWKS 
    },
    "client2": {
        "client_id": "client2-${CLIENT_AUTH_TYPE}-${ROS_ALG}-${TOKEN_ALG}",
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

generateConfig private_key_jwt PS256 PS256 > fapi1-advanced-final-with-private-key-PS256-PS256.json
generateConfig private_key_jwt ES256 ES256 > fapi1-advanced-final-with-private-key-ES256-ES256.json
generateConfig private_key_jwt RS256 PS256 > fapi1-advanced-final-with-private-key-RS256-PS256.json

generateConfig mtls PS256 PS256 > fapi1-advanced-final-with-mtls-PS256-PS256.json
generateConfig mtls ES256 ES256 > fapi1-advanced-final-with-mtls-ES256-ES256.json
generateConfig mtls RS256 PS256 > fapi1-advanced-final-with-mtls-RS256-PS256.json

