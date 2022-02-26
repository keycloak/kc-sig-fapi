#!/bin/sh

set -e
cleanup() {
    echo
    echo
    echo "`date '+%Y-%m-%d %H:%M:%S'`: run-tests.sh exiting"
    echo
    echo
}
trap cleanup EXIT

echo
echo
echo "`date '+%Y-%m-%d %H:%M:%S'`: run-tests.sh starting"
echo
echo

# to run tests against a cloud environment, you need to:
# 1. create an API token
# 2. set the CONFORMANCE_TOKEN environment variable to the token
# 3. do "source demo-environ.sh" (or whichever environment you want to run against)
# (to run against your local deployment, just don't do the 'source' command)

export TEST_CONFIG_ALIAS='test/a/fintech-clienttest/'
export OIDCC_TEST_CONFIG_ALIAS='test/a/openidfoundationinternal-clienttest/'
export ACCOUNTS='test-mtls/a/fintech-clienttest/open-banking/v1.1/accounts'
export ACCOUNT_REQUEST='test/a/fintech-clienttest/open-banking/v1.1/account-requests'

TESTS=""
EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/expected-failures-server.json|../conformance-suite/.gitlab-ci/expected-failures-ciba.json|../conformance-suite/.gitlab-ci/expected-failures-client.json"
EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-server.json|../conformance-suite/.gitlab-ci/expected-skips-ciba.json|../conformance-suite/.gitlab-ci/expected-skips-client.json"

makeClientTest() {
    . node-client-setup.sh
    . node-core-client-setup.sh

    # client FAPI1-ADVANCED-FINAL
    TESTS="${TESTS} fapi1-advanced-final-client-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi] automated-ob-client-test.json"
    TESTS="${TESTS} fapi1-advanced-final-client-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi] automated-ob-client-test.json"

    # client FAPI1-ADVANCED-FINAL-OB
    TESTS="${TESTS} fapi1-advanced-final-client-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_uk] automated-ob-client-test.json"
    TESTS="${TESTS} fapi1-advanced-final-client-test-plan[client_auth_type=mtls][fapi_profile=openbanking_uk] automated-ob-client-test.json"

	# client OpenID Connect Core Client Tests
    TESTS="${TESTS} oidcc-client-test-plan(../conformance-suite/.gitlab-ci/oidcc-rp-tests-config.json) automated-oidcc-client-test.json"
    # OIDC Core RP refresh token tests
    TESTS="${TESTS} oidcc-client-refreshtoken-test-plan(../conformance-suite/.gitlab-ci/oidcc-rp-refreshtoken-test-plan-config.json) automated-oidcc-client-test.json"
}

makeServerTest() {
    # OIDCC certification tests - static server, static client configuration
#    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"
#    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"
#    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"
#    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"
#    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"
#    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=static][client_registration=static_client] authlete-oidcc-secret-basic-server-static.json"

    # OIDCC certification tests - server supports discovery, static client
#    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-config-certification-test-plan authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] authlete-oidcc-secret-basic.json"
#
#    # OIDCC certification tests - server supports discovery, using dcr
#    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-config-certification-test-plan authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-dynamic-certification-test-plan[response_type=code\ id_token] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"
#    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] authlete-oidcc-dcr.json"

    # OIDCC
    # commented out tests removed as they don't test something significantly different, in order to keep the test time down
    # client_secret_basic - static client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-basic.json"

    # client_secret_basic - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"

    # client_secret_post - static client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-post.json"

    # client_secret_post - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"

    # client_secret_jwt - static client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-secret-jwt.json"

    # client_secret_jwt - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"

    # private_key_jwt - static client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ token][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token\ token][response_mode=default][client_registration=static_client] authlete-oidcc-privatekey.json"

    # private_key_jwt - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] authlete-oidcc-dcr.json"

    # form post
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token][response_mode=form_post][client_registration=dynamic_client] authlete-oidcc-dcr.json"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token\ token][response_mode=form_post][client_registration=dynamic_client] authlete-oidcc-dcr.json"


    # authlete openbanking
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_uk][fapi_response_mode=plain_response] authlete-fapi1-advanced-final-ob-mtls.json"
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_uk][fapi_response_mode=plain_response] authlete-fapi1-advanced-final-ob-privatekey.json"

    # authlete FAPI
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response] authlete-fapi1-advanced-final-mtls.json"
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response] authlete-fapi1-advanced-final-privatekey.json"
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm] authlete-fapi1-advanced-final-mtls-jarm.json"
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm] authlete-fapi1-advanced-final-privatekey-jarm.json"
#    TESTS="${TESTS} fapi-r-test-plan[fapir_client_auth_type=mtls] authlete-fapi-r-mtls.json"
#    TESTS="${TESTS} fapi-r-test-plan[fapir_client_auth_type=private_key_jwt] authlete-fapi-r-private-key.json"
#    TESTS="${TESTS} fapi-r-test-plan[fapir_client_auth_type=client_secret_jwt] authlete-fapi-r-client-secret.json"
#    TESTS="${TESTS} fapi-r-test-plan[fapir_client_auth_type=none] authlete-fapi-r-pkce.json"

    # This is the configuration used in the instructions as an example.
    # We keep it here as we want to be sure code changes don't break the example in the instructions, but the downside is there
    # is a chance that users may be using the alias at the same time our tests are running
#    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response] authlete-fapi1-advanced-final-privatekey-for-instructions.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-ES256-ES256-automated.json"
}

makeFAPI1AdvancedTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-ES256-ES256-automated.json"    
}

makeManualFAPI1AdvancedTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-ES256-ES256.json"    
}

makeFAPI1AdvancedPARTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-mtls-ES256-ES256-automated.json"
}

makeManualFAPI1AdvancedPARTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-mtls-ES256-ES256.json"
}

makeFAPI1AdvancedJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-mtls-ES256-ES256-automated.json"    
}

makeManualFAPI1AdvancedJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-jarm-mtls-ES256-ES256.json"    
}

makeFAPI1AdvancedPARJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-mtls-ES256-ES256-automated.json"
}

makeManualFAPI1AdvancedPARJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi1-advanced-par-jarm-mtls-ES256-ES256.json"
}

makeCIBAPollTest() {
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-mtls-ES256-ES256-automated.json"
}

makeManualCIBAPollTest() {
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=poll][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-poll-mtls-ES256-ES256.json"
}

makeCIBAPingTest() {
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-private-key-ES256-ES256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-mtls-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-mtls-ES256-ES256-automated.json"
}

makeManualCIBAPingTest() {
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=private_key_jwt][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-private-key-ES256-ES256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-mtls-PS256-PS256.json"
    TESTS="${TESTS} fapi-ciba-id1-test-plan[client_auth_type=mtls][fapi_profile=plain_fapi][ciba_mode=ping][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/fapi-ciba-id1-ping-mtls-ES256-ES256.json"
}

makeOBBRFAPI1AdvancedTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-final-with-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-final-with-mtls-PS256-PS256-automated.json"   
}

makeManualOBBRFAPI1AdvancedTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-final-with-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-final-with-mtls-PS256-PS256.json"
}

makeOBBRFAPI1AdvancedPARTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-mtls-PS256-PS256-automated.json"   
}

makeManualOBBRFAPI1AdvancedPARTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=plain_response][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-mtls-PS256-PS256.json"   
}

makeOBBRFAPI1AdvancedJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-jarm-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-jarm-mtls-PS256-PS256-automated.json" 
}

makeManualOBBRFAPI1AdvancedJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-jarm-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=by_value] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-jarm-mtls-PS256-PS256.json"  
}

makeOBBRFAPI1AdvancedPARJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-jarm-private-key-PS256-PS256-automated.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-jarm-mtls-PS256-PS256-automated.json" 
}

makeManualOBBRFAPI1AdvancedPARJARMTest() {
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=private_key_jwt][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-jarm-private-key-PS256-PS256.json"
    TESTS="${TESTS} fapi1-advanced-final-test-plan[client_auth_type=mtls][fapi_profile=openbanking_brazil][fapi_response_mode=jarm][fapi_auth_request_method=pushed] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/ob-br-fapi1-advanced-par-jarm-mtls-PS256-PS256.json"  
}

makeManualOIDCConfigTest() {
    TESTS="${TESTS} oidcc-config-certification-test-plan ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-config.json"
}

makeOIDCConfigTest() {
    TESTS="${TESTS} oidcc-config-certification-test-plan ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-config-automated.json"
}

makeManualOIDCBasicTest() {
    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-basic.json"
}

makeOIDCBasicTest() {
    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-basic-automated.json"
}

makeManualOIDCImplicitTest() {
    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-implicit.json"
}

makeOIDCImplicitTest() {
    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-implicit-automated.json"
}

makeManualOIDCHybridTest() {
    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-hybrid.json"
}

makeOIDCHybridTest() {
    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-hybrid-automated.json"
}

makeManualOIDCFormPostBasicTest() {
    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-basic.json"
}

makeOIDCFormPostBasicTest() {
    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-basic-automated.json"
}

makeManualOIDCFormPostHybridTest() {
    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-hybrid.json"
}

makeOIDCFormPostHybridTest() {
    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-hybrid-automated.json"
}

makeManualOIDCFormPostImplicitTest() {
    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-implicit.json"
}

makeOIDCFormPostImplicitTest() {
    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=discovery][client_registration=static_client] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-formpost-implicit-automated.json"
}

makeManualOIDCDynamicTest() {
    TESTS="${TESTS} oidcc-dynamic-certification-test-plan[response_type=code\ id_token] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-dynamic.json"
}

makeOIDCDynamicTest() {
    TESTS="${TESTS} oidcc-dynamic-certification-test-plan[response_type=code\ id_token] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-dynamic-automated.json"
}

makeManualOIDC3rdpartyInitLoginTest() {
    TESTS="${TESTS} oidcc-3rdparty-init-login-certification-test-plan[response_type=code\ id_token] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-3rdparty-init-login.json"
}

makeOIDC3rdpartyInitLoginTest() {
    TESTS="${TESTS} oidcc-3rdparty-init-login-certification-test-plan[response_type=code\ id_token] ../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/oidcc-3rdparty-init-login-automated.json"
}

makeLocalProviderTests() {
    # OIDCC certification tests - server supports discovery, using dcr
    TESTS="${TESTS} oidcc-basic-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-implicit-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-hybrid-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-config-certification-test-plan ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-dynamic-certification-test-plan[response_type=code\ id_token] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-formpost-basic-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-formpost-implicit-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-formpost-hybrid-certification-test-plan[server_metadata=discovery][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

    # OIDCC
    # client_secret_basic - dynamic client
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_basic][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

    # client_secret_post - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

    # client_secret_jwt - dynamic client
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

    # private_key_jwt - dynamic client
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    #TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=code\ id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=private_key_jwt][response_type=id_token\ token][response_mode=default][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

    # form post
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_post][response_type=code\ id_token][response_mode=form_post][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"
    TESTS="${TESTS} oidcc-test-plan[client_auth_type=client_secret_jwt][response_type=code][response_mode=form_post][client_registration=dynamic_client] ../conformance-suite/.gitlab-ci/local-provider-oidcc.plan"

}

if [ "$#" -eq 0 ]; then
    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
    TESTS="${TESTS} --show-untested-test-modules all"
    echo "Run all tests"
    makeServerTest
    makeClientTest
elif [ "$#" -eq 1 ] && [ "$1" = "--server-tests-only" ]; then
    echo "Run all tests"
    makeFAPI1AdvancedTest
    makeFAPI1AdvancedPARTest
    makeFAPI1AdvancedJARMTest
    makeFAPI1AdvancedPARJARMTest
    makeCIBAPollTest
    makeCIBAPingTest
    makeOBBRFAPI1AdvancedTest
    makeOBBRFAPI1AdvancedPARTest
    makeOBBRFAPI1AdvancedJARMTest
    makeOBBRFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi1-advanced-all" ]; then
    echo "Run fapi1-advanced all tests"
    makeFAPI1AdvancedTest
    makeFAPI1AdvancedPARTest
    makeFAPI1AdvancedJARMTest
    makeFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi-ciba-all" ]; then
    echo "Run fapi-ciba all tests"
    makeCIBAPollTest
    makeCIBAPingTest
elif [ "$#" -eq 1 ] && [ "$1" = "--ob-br-fapi1-advanced-all" ]; then
    echo "Run ob-br-fapi1-advanced all tests"
    makeOBBRFAPI1AdvancedTest
    makeOBBRFAPI1AdvancedPARTest
    makeOBBRFAPI1AdvancedJARMTest
    makeOBBRFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-all" ]; then
    echo "Run oidc all tests"
    makeOIDCConfigTest
    makeOIDCBasicTest
    makeOIDCImplicitTest
    makeOIDCHybridTest
    makeOIDCFormPostBasicTest
    makeOIDCFormPostImplicitTest
    makeOIDCFormPostHybridTest
    makeOIDCDynamicTest
    makeOIDC3rdpartyInitLoginTest
elif [ "$#" -eq 1 ] && [ "$1" = "--client-tests-only" ]; then
    EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/expected-failures-client.json"
    EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-client.json"
    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
    TESTS="${TESTS} --show-untested-test-modules client"
    echo "Run client tests"
    makeClientTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi1-advanced" ]; then
#    EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/expected-failures-server.json"
#    EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-server.json"
#    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
#    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
#    TESTS="${TESTS} --show-untested-test-modules server"
    echo "Run fapi1-advanced tests"
    makeFAPI1AdvancedTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi1-advanced" ]; then
    echo "Run fapi1-advanced tests manually"
    makeManualFAPI1AdvancedTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi1-advanced-par" ]; then
    echo "Run fapi1-advanced PAR tests"
    makeFAPI1AdvancedPARTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi1-advanced-par" ]; then
    echo "Run fapi1-advanced PAR tests manually"
    makeManualFAPI1AdvancedPARTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi1-advanced-jarm" ]; then
    echo "Run fapi1-advanced JARM tests"
    makeFAPI1AdvancedJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi1-advanced-jarm" ]; then
    echo "Run fapi1-advanced JARM tests manually"
    makeManualFAPI1AdvancedJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi1-advanced-par-jarm" ]; then
    echo "Run fapi1-advanced PAR JARM tests"
    makeFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi1-advanced-par-jarm" ]; then
    echo "Run fapi1-advanced PAR JARM tests manually"
    makeManualFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi-ciba-poll-id1" ]; then
    EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/expected-failures-ciba.json"
#    EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-ciba.json"
    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
#    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
    TESTS="${TESTS} --show-untested-test-modules ciba"
    echo "Run fapi-ciba poll mode tests"
    makeCIBAPollTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi-ciba-poll-id1" ]; then
    echo "Run fapi-ciba poll mode tests manually"
    makeManualCIBAPollTest
elif [ "$#" -eq 1 ] && [ "$1" = "--fapi-ciba-ping-id1" ]; then
    EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/fapi-conformance-suite-configs/expected-failures-ciba.json"
#    EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-ciba.json"
    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
#    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
    TESTS="${TESTS} --show-untested-test-modules ciba"
    echo "Run fapi-ciba ping mode tests"
    makeCIBAPingTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-fapi-ciba-ping-id1" ]; then
    echo "Run fapi-ciba ping mode tests manually"
    makeManualCIBAPingTest
elif [ "$#" -eq 1 ] && [ "$1" = "--ob-br-fapi1-advanced" ]; then
    echo "Run Open Banking Brasil fapi1-advanced tests"
    makeOBBRFAPI1AdvancedTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-ob-br-fapi1-advanced" ]; then
    echo "Run Open Banking Brasil fapi1-advanced tests manually"
    makeManualOBBRFAPI1AdvancedTest
elif [ "$#" -eq 1 ] && [ "$1" = "--ob-br-fapi1-advanced-par" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-par tests"
    makeOBBRFAPI1AdvancedPARTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-ob-br-fapi1-advanced-par" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-par tests manually"
    makeManualOBBRFAPI1AdvancedPARTest
elif [ "$#" -eq 1 ] && [ "$1" = "--ob-br-fapi1-advanced-jarm" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-jarm tests"
    makeOBBRFAPI1AdvancedJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-ob-br-fapi1-advanced-jarm" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-jarm tests manually"
    makeManualOBBRFAPI1AdvancedJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--ob-br-fapi1-advanced-par-jarm" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-par-jarm tests"
    makeOBBRFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-ob-br-fapi1-advanced-par-jarm" ]; then
    echo "Run Open Banking Brasil fapi1-advanced-par-jarm tests manually"
    makeManualOBBRFAPI1AdvancedPARJARMTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-config" ]; then
    echo "Run OpenID Connect Core: Config Certification Profile Authorization server tests"
    makeOIDCConfigTest   
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-config" ]; then
    echo "Run OpenID Connect Core: Config Certification Profile Authorization server tests manually"
    makeManualOIDCConfigTest 
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-basic" ]; then
    echo "Run OpenID Connect Core: Basic Certification Profile Authorization server test"
    makeOIDCBasicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-basic" ]; then
    echo "Run OpenID Connect Core: Basic Certification Profile Authorization server test manually"
    makeManualOIDCBasicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-implicit" ]; then
    echo "Run OpenID Connect Core: Implicit Certification Profile Authorization server test"
    makeOIDCImplicitTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-implicit" ]; then
    echo "Run OpenID Connect Core: Implicit Certification Profile Authorization server test manually"
    makeManualOIDCImplicitTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-hybrid" ]; then
    echo "Run OpenID Connect Core: Hybrid Certification Profile Authorization server test"
    makeOIDCHybridTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-hybrid" ]; then
    echo "Run OpenID Connect Core: Hybrid Certification Profile Authorization server test manually"
    makeManualOIDCHybridTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-formpost-basic" ]; then
    echo "Run OpenID Connect Core: Form Post Basic Certification Profile Authorization server test"
    makeOIDCFormPostBasicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-formpost-basic" ]; then
    echo "Run OpenID Connect Core: Form Post Basic Certification Profile Authorization server test manually"
    makeManualOIDCFormPostBasicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-formpost-hybrid" ]; then
    echo "Run OpenID Connect Core: Form Post Hybrid Certification Profile Authorization server test"
    makeOIDCFormPostHybridTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-formpost-hybrid" ]; then
    echo "Run OpenID Connect Core: Form Post Hybrid Certification Profile Authorization server test manually"
    makeManualOIDCFormPostHybridTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-formpost-implicit" ]; then
    echo "Run OpenID Connect Core: Form Post Implicit Certification Profile Authorization server test"
    makeOIDCFormPostImplicitTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-formpost-implicit" ]; then
    echo "Run OpenID Connect Core: Form Post Implicit Certification Profile Authorization server test manually"
    makeManualOIDCFormPostImplicitTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-formpost" ]; then
    echo "Run OpenID Connect Core: Form Post Certification Profile Authorization server test"
    makeOIDCFormPostBasicTest
    makeOIDCFormPostImplicitTest
    makeOIDCFormPostHybridTest 
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-dynamic" ]; then
    echo "Run OpenID Connect Core: Dynamic Certification Profile Authorization server test"
    makeOIDCDynamicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-dynamic" ]; then
    echo "Run OpenID Connect Core: Dynamic Certification Profile Authorization server test manually"
    makeManualOIDCDynamicTest
elif [ "$#" -eq 1 ] && [ "$1" = "--oidcc-3rdparty-init-login" ]; then
    echo "Run OpenID Connect Core: 3rd party initiated Certification Profile Authorization server test"
    makeOIDC3rdpartyInitLoginTest
elif [ "$#" -eq 1 ] && [ "$1" = "--manual-oidcc-3rdparty-init-login" ]; then
    echo "Run OpenID Connect Core: 3rd party initiated Certification Profile Authorization server test"
    makeManualOIDC3rdpartyInitLoginTest   
elif [ "$#" -eq 1 ] && [ "$1" = "--local-provider-tests" ]; then
    EXPECTED_FAILURES_FILE="../conformance-suite/.gitlab-ci/expected-failures-local.json"
    EXPECTED_SKIPS_FILE="../conformance-suite/.gitlab-ci/expected-skips-local.json"
    TESTS="${TESTS} --expected-failures-file ${EXPECTED_FAILURES_FILE}"
    TESTS="${TESTS} --expected-skips-file ${EXPECTED_SKIPS_FILE}"
    echo "Run local provider tests"
    makeLocalProviderTests
else
    echo "Syntax: run-tests.sh [--server-tests-only|--fapi1-advanced-all|--fapi-ciba-all|--ob-br-fapi1-advanced-all|--client-tests-only|--fapi1-advanced|--fapi-ciba-poll-id1|--fapi1-advanced-par|--fapi1-advanced-jarm|--fapi1-advanced-par-jarm|--ob-br-fapi1-advanced|--ob-br-fapi1-advanced-par|--ob-br-fapi1-advanced-jarm|--ob-br-fapi1-advanced-par-jarm|
    --local-provider-tests]"
    exit 1
fi

echo ${TESTS} | xargs /conformance-suite/scripts/run-test-plan.py
