FROM quay.io/keycloak/keycloak:10.0.1

USER root

# Realm config
ADD --chown=jboss:jboss realm.json /opt/jboss/

ENV KEYCLOAK_IMPORT=/opt/jboss/realm.json
ENV X509_CA_BUNDLE=/etc/x509/https/client-ca.crt

