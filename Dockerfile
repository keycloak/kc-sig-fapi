FROM golang:1.12.5 as builder

ENV GO111MODULE=on
WORKDIR /go/src/github.com/soss-sig/keycloak-fapi
COPY resource-server/* ./
RUN go build -o resource-server *.go


FROM jboss/keycloak:6.0.1

USER root

# Install keyclaok-gatekeeper
RUN curl -s https://downloads.jboss.org/keycloak/6.0.1/gatekeeper/keycloak-gatekeeper-linux-amd64.tar.gz | tar zx -C /usr/local/sbin/
RUN mkdir -p /opt/jboss/keycloak-gatekeeper
ADD resource-server/config.yml /opt/jboss/keycloak-gatekeeper/config.yml
ADD resource-server/*-server-info.txt /opt/jboss/keycloak-gatekeeper/

# Install resource-server for testing
COPY --from=builder /go/src/github.com/soss-sig/keycloak-fapi/resource-server /usr/local/sbin/

# For TLS
RUN mkdir -p /etc/x509/https

ADD --chown=jboss:jboss https/server.pem /etc/x509/https/tls.crt
ADD --chown=jboss:jboss https/server-key.pem /etc/x509/https/tls.key
ADD --chown=jboss:jboss https/ca.pem /etc/x509/https/client-ca.crt

# Realm config
ADD --chown=jboss:jboss realm/realm.json /opt/jboss/


USER jboss

ADD docker-entrypoint-wrapper.sh /opt/jboss/tools/

ENV KEYCLOAK_IMPORT=/opt/jboss/realm.json
ENV X509_CA_BUNDLE=/etc/x509/https/client-ca.crt

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint-wrapper.sh" ]
