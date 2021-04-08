#!/bin/sh

# Wait for server to start before running tests - check every 30s
# On some platforms (For example Ubuntu 18.0.4), the docker host available on 172.17.0.1
until $(curl -k --output /dev/null --silent --head --fail https://host.docker.internal:8443) ||  $(curl -k --output /dev/null --silent --head --fail https://172.17.0.1:8443)
do
    echo "Still waiting for 'docker internal host' to be available";
    sleep 30
done

echo "The 'docker internal host' available. Waiting 40 seconds before starting tests"

# Sometimes keycloak is still starting up at this point if no maven dependencies need downloading in server service (sleep 40)
sleep 40

docker exec keycloak-fapi_server_1 bash -c "chmod a+x /conformance-suite/.gitlab-ci/run-tests.sh"
docker exec keycloak-fapi_server_1 bash -c "chmod a+x /conformance-suite/scripts/*"
 
[ $AUTOMATE_TESTS == true ] &&
docker exec keycloak-fapi_server_1 bash -c "/conformance-suite/.gitlab-ci/run-tests.sh --server-tests-only"