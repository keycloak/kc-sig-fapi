ARG KEYCLOAK_BASE_IMAGE
FROM ${KEYCLOAK_BASE_IMAGE}

# For FAPI-1-Final-Advanced, section 8.5
# see org.keycloak.quarkus.runtime.configuration.mappers.HttpPropertyMappers
ENV KC_HTTPS_PROTOCOLS=TLSv1.2
ENV KC_HTTPS_CIPHER_SUITES=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
ENV KC_HTTPS_PORT=9443

USER root

# Add certificates
COPY server.pem /etc/x509/https/server.crt
COPY client-ca.pem /etc/x509/https/client-ca.crt

RUN \
  echo "Importing certificates into truststore" && \
  keytool -import -cacerts -storepass changeit -noprompt -file /etc/x509/https/server.crt -alias myservercrt && \
  keytool -import -cacerts -storepass changeit -noprompt -file /etc/x509/https/client-ca.crt  -alias myclientcacrt && \
  echo "Certificates imported"


# Custom SPIs
COPY ${KEYCLOAK_SPI_0} /opt/keycloak/providers/

# Custom OIDC metadata
COPY oidf.json /opt/keycloak/conf

# SPI Customizations
COPY keycloak-custom.properties /opt/keycloak/conf
RUN cat /opt/keycloak/conf/keycloak-custom.properties >> /opt/keycloak/conf/keycloak.conf

USER keycloak
