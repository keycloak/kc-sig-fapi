FROM jboss/keycloak:6.0.1

USER root
RUN yum update curl nss

RUN mkdir -p /etc/x509/https

ADD --chown=jboss:jboss https/server.pem /etc/x509/https/tls.crt
ADD --chown=jboss:jboss https/server-key.pem /etc/x509/https/tls.key
ADD --chown=jboss:jboss https/ca.pem /etc/x509/https/client-ca.crt

ADD --chown=jboss:jboss realm/realm.json /opt/jboss/

USER jboss

ENV KEYCLOAK_IMPORT=/opt/jboss/realm.json
ENV X509_CA_BUNDLE=/etc/x509/https/client-ca.crt

