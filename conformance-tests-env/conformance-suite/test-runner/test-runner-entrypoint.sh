#!/bin/sh

# Wait for server to start before running tests - check every 30s
# On some platforms (For example Ubuntu 18.0.4), the docker host available on 172.17.0.1
until $(curl -k --output /dev/null --silent --head --fail https://host.docker.internal:8443) ||  $(curl -k --output /dev/null --silent --head --fail https://172.17.0.1:8443)
do
    echo "Still waiting for 'docker internal host' to be available";
    sleep 30
done

echo "The 'docker internal host' available. Waiting 90 seconds before starting tests"

# Sometimes keycloak is still starting up at this point if no maven dependencies need downloading in server service (sleep 90)
sleep 90

docker exec keycloak-fapi-server-1 bash -c "chmod a+x /conformance-suite/.gitlab-ci/run-tests.sh"
docker exec keycloak-fapi-server-1 bash -c "chmod a+x /conformance-suite/scripts/*"
docker exec keycloak-fapi-server-1 bash -c "apk add --update --upgrade --no-cache python3-pip"
docker exec keycloak-fapi-server-1 bash -c "apk update && apk add --no-cache py3-pip"
docker exec keycloak-fapi-server-1 bash -c "pip3 install httpx pyparsing"

[ $AUTOMATE_TESTS == true ] &&
docker exec keycloak-fapi-server-1 bash -c "/conformance-suite/.gitlab-ci/run-tests.sh $TEST_PLAN"