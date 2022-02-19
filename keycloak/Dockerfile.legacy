ARG KEYCLOAK_LEGACY_BASE_IMAGE
FROM ${KEYCLOAK_LEGACY_BASE_IMAGE}
ARG KEYCLOAK_REALM_IMPORT_FILENAME
# For FAPI-1-Final-Advanced, section 8.5
RUN sed -i -e "s/(key-manager=kcKeyManager)/(key-manager=kcKeyManager,protocols=[\"TLSv1.2\"],cipher-suite-filter=\"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384\")/" /opt/jboss/tools/cli/x509-keystore.cli

USER root

# Realm config
ADD --chown=jboss:jboss ${KEYCLOAK_REALM_IMPORT_FILENAME} /opt/jboss/

# Custom SPIs
COPY ${KEYCLOAK_SPI_0} /opt/jboss/keycloak/standalone/deployments/

ENV KEYCLOAK_IMPORT=/opt/jboss/${KEYCLOAK_REALM_IMPORT_FILENAME}
ENV X509_CA_BUNDLE="/etc/x509/https/client-ca.crt /etc/x509/https/server.crt"

COPY ciba.cli /opt/jboss/keycloak/bin/
RUN /opt/jboss/keycloak/bin/jboss-cli.sh --file=/opt/jboss/keycloak/bin/ciba.cli

COPY oidf.json /opt/jboss/keycloak/standalone/configuration
COPY well-known.cli /opt/jboss/keycloak/bin/
RUN /opt/jboss/keycloak/bin/jboss-cli.sh --file=/opt/jboss/keycloak/bin/well-known.cli