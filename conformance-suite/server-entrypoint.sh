#!/bin/sh
cd conformance-suite
mv -f run-tests.sh ./.gitlab-ci
mvn package -DskipTests
java -Xdebug -Xrunjdwp:transport=dt_socket,address=*:9999,server=y,suspend=n \
    -jar target/fapi-test-suite.jar \
    -Djava.security.egd=file:/dev/./urandom \
    --fintechlabs.base_url=${CONFORMANCE_SERVER} \
    --fintechlabs.devmode=true \
    --fintechlabs.startredir=true \
    --logging.level.net.openid.conformance.frontChannel=DEBUG