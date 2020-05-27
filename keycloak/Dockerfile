FROM jboss/keycloak:6.0.1

USER root

# Realm config
ADD --chown=jboss:jboss realm.json /opt/jboss/

ENV KEYCLOAK_IMPORT=/opt/jboss/realm.json
ENV X509_CA_BUNDLE=/etc/x509/https/client-ca.crt

# workaround for https://github.com/jsoss-sig/keycloak-fapi/issues/6
# also see https://issues.jboss.org/browse/WFLY-11007
RUN rm /etc/pki/ca-trust/extracted/java/cacerts
