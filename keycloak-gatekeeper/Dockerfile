FROM golang:1.12.6 as builder

ENV GO111MODULE=on
WORKDIR /go/src/github.com/soss-sig/
RUN git clone https://github.com/openstandia/keycloak-gatekeeper.git
WORKDIR /go/src/github.com/soss-sig/keycloak-gatekeeper
RUN git checkout fapi
RUN make static


FROM keycloak/keycloak-gatekeeper:6.0.1

COPY --from=builder /go/src/github.com/soss-sig/keycloak-gatekeeper/bin/keycloak-gatekeeper /opt/keycloak-gatekeeper

ADD config.yml /opt/config.yml
ADD docker-entrypoint.sh /usr/local/sbin/

ENTRYPOINT [ "docker-entrypoint.sh" ]

