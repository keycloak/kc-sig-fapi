#!/bin/sh

/opt/keycloak-gatekeeper \
    --config /opt/config.yml \
    --discovery-url https://${KEYCLOAK_FQDN}/auth/realms/${KEYCLOAK_REALM} \
    --listen 0.0.0.0:10443

