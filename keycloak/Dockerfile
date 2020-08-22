FROM quay.io/keycloak/keycloak:11.0.1

# For FAPI-RW-8.5-2
RUN sed -i -e "s/(key-manager=kcKeyManager)/(key-manager=kcKeyManager,protocols=[\"TLSv1.2\"],cipher-suite-filter=\"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256\")/" /opt/jboss/tools/cli/x509-keystore.cli

USER root

# Realm config
ADD --chown=jboss:jboss realm.json /opt/jboss/

ENV KEYCLOAK_IMPORT=/opt/jboss/realm.json
ENV X509_CA_BUNDLE=/etc/x509/https/client-ca.crt
