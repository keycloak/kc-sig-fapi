#!/bin/sh

# Wait for server to start before running tests - check every 30s
until $(curl -k --output /dev/null --silent --head --fail https://host.docker.internal:8443)
do
    sleep 30
done

# Sometimes keycloak is still starting up at this point if no maven dependencies need downloading in server service (sleep 20)
sleep 20
 
[ $AUTOMATE_TESTS == true ] &&
docker exec keycloak-fapi_server_1 bash -c "/conformance-suite/.gitlab-ci/run-tests.sh --server-tests-only"