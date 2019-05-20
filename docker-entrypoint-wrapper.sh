#!/bin/bash

# Start Keycloak Server
/opt/jboss/tools/docker-entrypoint.sh $@ &
sleep 30

# Start Resource Server
resource-server &

# Start Keycloak Gatekeeper
REALM=`cat /opt/jboss/realm.json | grep '"realm":' | cut -d'"' -f 4`
KC_HOST_PORT=`cat /opt/jboss/keycloak-gatekeeper/keycloak-server-info.txt`
RS_HOST_PORT=`cat /opt/jboss/keycloak-gatekeeper/resource-server-info.txt`
RS_PORT=`echo $RS_HOST_PORT | cut -d":" -f 2`

keycloak-gatekeeper --config /opt/jboss/keycloak-gatekeeper/config.yml \
    --discovery-url https://${KC_HOST_PORT}/auth/realms/${REALM} \
    --listen 0.0.0.0:${RS_PORT}

