ARG KEYCLOAK_BASE_IMAGE

FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs curl --releasever 9 --setopt install_weak_deps=false --nodocs -y; dnf --installroot /mnt/rootfs clean all

FROM ${KEYCLOAK_BASE_IMAGE}

COPY --from=ubi-micro-build /mnt/rootfs /

# https://datatracker.ietf.org/doc/html/rfc9325.html#section-4.2
ENV KC_HTTPS_PROTOCOLS=TLSv1.2
ENV KC_HTTPS_CIPHER_SUITES=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
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

USER 1001
