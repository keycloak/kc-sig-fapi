# FAPI-SIG (Financial-grade API Security : Special Interest Group)

## Overview

FAPI-SIG is a group whose activity is mainly supporting [Financial-grade API (FAPI)](https://openid.net/wg/fapi/) and its related specifications to keycloak.

FAPI-SIG is open to everybody so that anyone can join it anytime. Nothing special need not to be done to join it. Who want to join it can only access to the communication channels shown below.  All of its activities and outputs are public so that anyone can access them.

FAPI-SIG mainly treats FAPI and its related specifications but not limited to. E.g., Ecosystems employing FAPI for their API Security like UK OpenBanking and Australia Consumer Data Right (CDR).

## Goals

Currently, proposed goals are as follows.

- [Read and Write API Security Profile (FAPI-RW)](https://openid.net/specs/openid-financial-api-part-2-ID2.html)
  - Implement and contribute necessary features
  - Pass FAPI-RW conformance tests (both FAPI-RW OP w/ MTLS and FAPI-RW OP w/ Private Key)
  - Get the certificates

- [Client Initiated Backchannel Authentication Profile (FAPI-CIBA)](https://openid.net/specs/openid-financial-api-ciba-ID1.html)
  - Implement and contribute necessary features
  - Pass FAPI-CIBA conformance tests (only both FAPI-CIBA OP poll w/ MTLS and FAPI-CIBA OP poll w/ Private Key)
  - Get the certificates

## Open Works

Currently, proposed open works are as follows.

- Integrating FAPI conformance tests run into keycloak’s CI/CD pipeline

- Implement [JWT Secured Authorization Response Mode for OAuth 2.0 (JARM)](https://openid.net/specs/openid-financial-api-jarm-ID1.html)

- Implement security profiles for Apps run on mobile devices
  - [RFC 8252 OAuth 2.0 for Native Apps](https://tools.ietf.org/html/rfc8252)
  - [OAuth 2.0 for Browser-Based Apps](https://tools.ietf.org/html/draft-ietf-oauth-browser-based-apps-06)

- Implement [FAPI-RW App2App](https://openid.net/2020/06/23/openid-foundation-announces-fapi-rw-app2app-certification-launched/)

## Communication Channels

Not only FAPI-SIG member but others can communicate with each other by the following ways.

- Mail : Google Group [keycloak developer mailing list](https://groups.google.com/forum/#!topic/keycloak-dev/Ck_1i5LHFrE)
- Chat : Zulip Chat stream ([#dev-sig-fapi](https://keycloak.zulipchat.com/#narrow/stream/248413-dev-sig-fapi))
- Meeting : Web meeting on a regular basis

## Working Repository

All of FAPI-SIG's activity outputs can be stored on [jsoss-sig/keycloak-fapi](https://github.com/jsoss-sig/keycloak-fapi/tree/master/FAPI-SIG) repository in github.

Who want to submit the output needs to send the pull-request to this repository.

## How to run FAPI Conformance suite with Keycloak server in your local machine

### Software requirements

* [Docker CE](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* JDK and [Maven](https://maven.apache.org/)

### Run FAPI Conformance suite server

Clone [FAPI Conformance suite repository](https://gitlab.com/openid/conformance-suite) and move into the directory.

```
git clone https://gitlab.com/openid/conformance-suite.git
cd conformance-suite
```

If you would like to run the server on Docker for Windows, add `volumes` for mongodb and use it in `docker-compose.yml` as follows. 

```
@@ -3,7 +3,7 @@ services:
   mongodb:
     image: mongo
     volumes:
-     - ./mongo/data:/data/db
+     - mongodata:/data/db
   httpd:
     build:
       context: ./httpd
@@ -36,3 +36,7 @@ services:
       options:
         max-size: "500k"
         max-file: "5"
+
+volumes:
+  mongodata:
+
```

Then, build the server using Maven.

```
mvn clean package
```

Finally, boot all the containers using Docker Compose.

```
docker-compose up
```

### Run Local Keycloak server

Clone [jsoss-sig/keycloak-fapi](https://github.com/jsoss-sig/keycloak-fapi) and move into the directory.

```
git clone https://github.com/jsoss-sig/keycloak-fapi.git
cd keycloak-fapi
```

This repository contains default self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.
If you would like to use the configurations as it is, you only need to build and boot all the containers using Docker Compose.

```
docker-compose up
```

### Modify your `hosts` file

To access to Keycloak and Resource server with FQDN, modify your `hosts` file in your local machine as follows.

```
127.0.0.1 as.keycloak-fapi.org rs.keycloak-fapi.org
```

### Run FAPI Conformance test plan

1. Open https://localhost:8443
2. Click `Create a new test plan` button.
3. Choose `FAPI-RW-ID2 (and OpenBankingUK): Authorization server test (latest version)` as Test Plan.
4. Choose `Client Authentication Type` you want to test.
5. Choose `plain_fapi` as FAPI Profile.
6. Choose `plain_response` as FAPI Response Mode.
7. Click `JSON` tab and paste content of the configuration.
  * If you want to use private_key_jwt client authentication, use [fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-PS256-PS256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-PS256-PS256.json) or [fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-ES256-ES256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-ES256-ES256.json).
  * If you want to use mtls client authentication, use [fapi-conformance-suite-configs/fapi-rw-id2-with-mtls-PS256-PS256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-mtls-PS256-PS256.json) or [fapi-conformance-suite-configs/fapi-rw-id2-with-mtls-ES256-ES256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-mtls-ES256-ES256.json).
8. Click `Create Test Plan` button and follow the instructions. To proceed with the tests, You can authenticate using `john` account with password `john`. When rejecting authentication scenario, you can use `mike` account with password `mike`. In this case, you need to click `No` button to cancel the authentication in the consent screen.


## How to deploy the servers on the internet

If you would like to deploy on the internet, follow instructions below which use Amazon Linux 2 on Amazaon EC2 as an example.

Install Docker.

```
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
```

Install Docker Compose.

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Clone sources from GitHub.

```
git clone https://gitlab.com/openid/conformance-suite.git
git clone https://github.com/jsoss-sig/keycloak-fapi.git
```

Export environment variables with the FQDN which you want to use.

```
export KEYCLOAK_FQDN=as.keycloak-fapi.org
export RESOURCE_FQDN=rs.keycloak-fapi.org
export CONFORMANCE_SUITE_FQDN=conformance-suite.keycloak-fapi.org
```

Modify `conformance-suite/docker-compose.xml` as follows.

**Note: We need to set `fintechlabs.base_url` with public FQDN to change from `https://localhost:8443`** 

```
       context: ./server-dev
     volumes:
      - ./target/:/server/
-    command: java -jar /server/fapi-test-suite.jar --fintechlabs.devmode=true --fintechlabs.startredir=true
+    command: java -jar /server/fapi-test-suite.jar --fintechlabs.devmode=true --fintechlabs.startredir=true --fintechlabs.base_url=https://${CONFORMANCE_SUITE_FQDN}
     links:
      - mongodb:mongodb
      - microauth:microauth
```

Build FAPI Conformance suite server and boot the all containers using Docker Compose.

```
cd conformance-suite
mvn clean package
docker-compose up -d
```

Generate server certificates, Keycloak realm config and FAPI Conformance suite configs with your FQDN.

```
cd ../keycloak-fapi
./setup-fqdn.sh
```

Boot the containers using Docker Compose.

```
docker-compose up -d
```


## For Developers

**Currently, generators of all configurations are written with bash script and some CLI tools for linux-amd64.**

Run `generate-all.sh` script simply to generate self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.

```
./generate-all.sh
```

Now, you can boot a Keyclaok server with new configurations.

```
docker-compose up --force-recreate
```

## Run FAPI Conformance test against local built keycloak

If you would like to run FAPI Conformance test against local built keycloak, modify `docker-compose.yml` as follows.

```
@@ -28,6 +28,7 @@ services:
      - ./https/server.pem:/etc/x509/https/tls.crt
      - ./https/server-key.pem:/etc/x509/https/tls.key
      - ./https/client-ca.pem:/etc/x509/https/client-ca.crt
+     - <path to locally built keycloak>:/opt/jboss/keycloak
     ports:
      - "8787:8787"
     environment:
```

It overrides the keycloak of the base image with the one built on the local machine.

## License

* [Apache License, Version 2.0](./LICENSE)

