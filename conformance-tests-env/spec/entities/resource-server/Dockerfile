FROM golang:1.12.5-alpine3.9 as builder

ENV GO111MODULE=on
WORKDIR /go/src/github.com/soss-sig/keycloak-fapi
COPY *.go ./
RUN go build -o resource-server *.go


FROM alpine:3.9

# Install resource-server for testing
COPY --from=builder /go/src/github.com/soss-sig/keycloak-fapi/resource-server /usr/local/sbin/

ENTRYPOINT [ "resource-server" ]

