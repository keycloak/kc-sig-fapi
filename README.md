# FAPI-SIG (Financial-grade API Security : Special Interest Group)

## Overview

FAPI-SIG is a group whose activity is mainly supporting [Financial-grade API (FAPI)](https://openid.net/wg/fapi/) and its related specifications to keycloak.

FAPI-SIG is open to everybody so that anyone can join it anytime. Nothing special need not to be done to join it. Who want to join it can only access to the communication channels shown below.  All of its activities and outputs are public so that anyone can access them.

FAPI-SIG mainly treats FAPI and its related specifications but not limited to. E.g., Ecosystems employing FAPI for their API Security like UK OpenBanking, Open Banking Brasil and Australia Consumer Data Right (CDR).

## Goals

Currently, proposed goals are as follows.

### Financial-grade API (FAPI) 2.0 related features

- [Financial-grade API (FAPI) 2.0 — Part 1: Baseline Security Profile](https://bitbucket.org/openid/fapi/src/master/FAPI_2_0_Baseline_Profile.md)

- [Financial-grade API (FAPI) 2.0 — Grant Management for OAuth 2.0](https://openid.net/specs/fapi-grant-management-01.html)

- [OAuth 2.0 Rich Authorization Requests (RAR)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-rar)

- [OAuth 2.0 Demonstrating Proof-of-Possession at the Application Layer (DPoP)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop)

### Nation/Region/Market Specific Features

- EU : PSD2/eIDAS - QWAC Verification Extension

## Open Works

Currently, proposed open works are as follows.

- Integrating FAPI conformance tests run into keycloak’s CI/CD pipeline

- Implement security profiles for Apps run on mobile devices
  - [RFC 8252 OAuth 2.0 for Native Apps](https://tools.ietf.org/html/rfc8252)
  - [OAuth 2.0 for Browser-Based Apps](https://tools.ietf.org/html/draft-ietf-oauth-browser-based-apps-06)

- [FAPI-RW App2App](https://openid.net/2020/06/23/openid-foundation-announces-fapi-rw-app2app-certification-launched/)

## Results

1 year past since 1st FAPI-SIG meeting had held on 4 Aug 2020.​

FAPI related accomplishments by FAPI-SIG, other contributors and keycloak development team is as follows.​

### Common Security Features

#### keycloak 14
 - [Client Policies](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)​

​
### Nation/Region/Market Specific Features

#### keycloak 15
 - [Brazil : Open Banking Brasil Financial-grade API Security Profile](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil) 
   
   mainly by keycloak development team.

### Standards​

#### keycloak 13

  - [Client Initiated Backchannel Authentication (CIBA) poll mode​](https://www.keycloak.org/docs/latest/release_notes/index.html#openid-connect-client-initiated-backchannel-authentication-ciba)

#### keycloak 14

  - [FAPI 1.0 Baseline Security Profile](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)​
  - [FAPI 1.0 Advanced Security Profile​](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)

#### keycloak 15

  - [Client Initiated Backchannel Authentication (CIBA) ping mode​](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil)

    mainly by keycloak development team.

  - [FAPI JWT Secured Authorization Response Mode for OAuth 2.0 (JARM)​](https://www.keycloak.org/docs/latest/release_notes/index.html#highlights)

    mainly by the contributor outside FAPI-SIG.

  - [FAPI Client Initiated Backchannel Authentication Profile (FAPI-CIBA)​](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil)

  - OAuth 2.0 Pushed Authorization Requests (PAR)

### Automated Conformance Test Run Environment by this kc-fapi-sig repository

The current environment uses the following software version.
- Keycloak version : 17.0.0
- Conformance-suite version : release-v4.1.41

#### FAPI 1.0 Advanced (Final)​
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256, ES256​
  - Request Object Method : plain, PAR​
  - Response Mode : plain, JARM​

Keycloak 15.0.2 have achieved [certification for all 8 conformance profiles of FAPI 1 Advanced Final (Generic)](https://openid.net/certification/#FAPI_OPs).


#### FAPI-CIBA (Implementer’s Draft)​
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256, ES256​
  - Mode : Poll, Ping

Keycloak 15.0.2 have achieved [certification for all 4 conformance profiles of Financial-grade API Client Initiated Backchannel Authentication Profile (FAPI-CIBA)](https://openid.net/certification/#FAPI-CIBA_OPs).

#### Open Banking Brasil FAPI 1.0
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256
  - Request Object Method : plain, PAR​
  - Response Mode : plain, JARM​

Keycloak 15.0.2 have achieved [certification for 8 conformance profiles Brazil Open Banking (Based on FAPI 1 Advanced Final)](https://openid.net/certification/#FAPI_OPs) except for DCR (Dynamic Client Registration).

#### OpenID Connect Core: Config Certification Profile

## Communication Channels

Not only FAPI-SIG member but others can communicate with each other by the following ways.

- Mail : Google Group [keycloak developer mailing list](https://groups.google.com/forum/#!topic/keycloak-dev/Ck_1i5LHFrE)
- Chat : Zulip Chat stream ([#dev-sig-fapi](https://keycloak.zulipchat.com/#narrow/stream/248413-dev-sig-fapi))
- Meeting : Web meeting on a regular basis

## Working Repository

Who want to submit the output needs to send the pull-request to this repository.

## How to run FAPI Conformance suite with Keycloak server in your local machine

### Software requirements

* [Docker CE](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* JDK and [Maven](https://maven.apache.org/)

#### Supported Docker Compose Version

It has been confirmed that this automated FAPI conformance test run environment works with docker-compose version 1.27.4.

How to use this version temporarily is as follows.

##### windows

Reference:
https://docs.docker.com/compose/install/#install-compose-on-windows-server

Invoke power shell with admin privilege and type the following command.

```
Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile $Env:ProgramFiles\Docker\docker-compose.exe
```

Instead of originally used docker-compose, use
"C:\Program Files\Docker\docker-compose.exe"

##### linux

Reference:
https://docs.docker.com/compose/install/#install-compose-on-linux-systems

```
sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Instead of originally used docker-compose, use
/usr/local/bin/docker-compose


### Run FAPI Conformance suite, Keycloak server and Test Runner

Edit `hosts` file as per the [Modify your hosts file](#Modify-your-hosts-file) section

This repository contains default self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.
If you would like to use the configurations as it is, you only need to build and boot all the containers using Docker Compose.

Run the following command from the project basedir to start the test suite

```
docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build
```
The OpenID FAPI Conformance test interface will then be reachable at [https://localhost:8443](https://localhost:8443).
See instructions in [Run FAPI Conformance test plan](#Run-FAPI-Conformance-test-plan) 
section for running the tests manually in your browser.

To stop all containers after the automated tests have run:

```
docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build --exit-code-from test_runner
```

Note: To run the Conformance test suite with wildfly based legacy Keycloak instead of quarkus based Keycloak, just replace
`docker-compose-keycloak.yml` with `docker-compose-keycloak-legacy.yml` in the previous above.

The following options can be set as environment variables before the above command:

* `KEYCLOAK_LEGACY_BASE_IMAGE` (default: quay.io/keycloak/keycloak:17.0.0-legacy)
    * The wildfly based keycloak image version used in the test suite
* `KEYCLOAK_BASE_IMAGE` (default: quay.io/keycloak/keycloak:17.0.0)
    * The keycloak image version used in the test suite
* `KEYCLOAK_REALM_IMPORT_FILENAME` (default: realm.json)
    * The keycloak realm import filename. Set this to `realm.json` if you are running the tests
    against a local build of keycloak.
* `AUTOMATE_TESTS` (default: true)
    * Set to false to stop conformance-suite tests automatically running
* `MVN_HOME` (default: ~/.m2)
    * Set to use a custom maven home path
* `OPENID_GIT_TAG` (default: release-v4.1.41)
    * The OpenID Conformance Suite Git Tag to be cloned    


**Example:**
```
KEYCLOAK_BASE_IMAGE=jboss/keycloak:17.0.0 docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build
```

To stop and remove all containers, run the following:
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```
Instead of this, if you want also to remove all the images and the volumes created by the docker-compose in addition to containers, you run this:
```
docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml down --rmi local -v
```

### Modify your `hosts` file

To access to Keycloak and Resource server with FQDN, modify your `hosts` file in your local machine as follows.

```
127.0.0.1 as.keycloak-fapi.org aes.keycloak-fapi.org rs.keycloak-fapi.org cs.keycloak-fapi.org conformance-suite.keycloak-fapi.org
```

### Run FAPI Conformance test plan manually

1. Run this project with `AUTOMATE_TESTS=false` environment variable set
2. Open https://conformance-suite.keycloak-fapi.org
3. Click `Create a new test plan` button.
4. Choose `FAPI1-Advanced-Final: Authorization server test` or `FAPI-RW-ID2 (and OpenBankingUK): Authorization server test (latest version)` as Test Plan.
The `FAPI1-Advanced-Final` is currently recommended as it tests against the Final version of the FAPI specification
5. Choose `Client Authentication Type` you want to test.
6. Choose `plain_fapi` as FAPI Profile.
7. Choose `plain_response` as FAPI Response Mode.
8. Click `JSON` tab and paste content of the configuration.
  * If you want to use private_key_jwt client authentication, use [fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-PS256-PS256.json](./fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-PS256-PS256.json) or [fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-ES256-ES256.json](./fapi-conformance-suite-configs/fapi1-advanced-final-with-private-key-ES256-ES256.json).
  * If you want to use mtls client authentication, use [fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-PS256-PS256.json](./fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-PS256-PS256.json) or [fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-ES256-ES256.json](./fapi-conformance-suite-configs/fapi1-advanced-final-with-mtls-ES256-ES256.json).
9. Click `Create Test Plan` button and follow the instructions.
10. If you used `FAPI1-Advanced-Final`, it is recommended to use Keycloak global builtin client profile `fapi-1-advanced` instead of the
`fapi-1-rw-ID2`, which is suitable for the `FAPI-RW-ID2` test profile. To do this, you can login to Keycloak admin console (should be available
usually under `https://as.keycloak-fapi.org/auth`) as admin/admin. Then go to Realm  `Test` -> `Client Policies` -> `Policies` -> `fapi-1-0-policy`. Then delete `fapi-1-rw-ID2` client profile
from this policy and add `fapi-1-advanced` instead of it. 
1.  To proceed with the tests, you can authenticate using `john` account with password `john`.
2.  When rejecting authentication scenario, you can use `mike` account with password `mike`. In this case, you need to click `No` button to cancel the authentication in the consent screen.
Before running this reject authentication test (Usually 3rd test in the conformance testsuite called something like `fapi1-advanced-final-user-rejects-authentication`),
it is recommended to login to Keycloak admin console as admin/admin and remove the existing session of user `john`. Alternative is to run this test in different browser
or clear cookies for Keycloak server.

### Run FAPI CIBA Conformance test plan manually

There are similar instructions like for the `FAPI1-Advanced-Final` described above, however you need to select
different configurations during test setup. Besides that, there are two additional things needed when running manual test:

1. If you want `fapi-ciba-id1-ensure-authorization-request-with-potentially-bad-binding-message` to NOT fail, you need
to skip automatic approval during the test. This means that you need to delete this line from the test JSON configuration
before you submit the configuration:
```
"automated_ciba_approval_url": "https://aes.keycloak-fapi.org/automated/ciba/approval?auth_req_id={auth_req_id}&action={action}"
```
2. Because of the point above, you need to "manually" tell the CIBA authentication server to reject requests at some point during the tests
and then allow them back. More specifically:
2.a) Before running 3rd test `fapi-ciba-id1-user-rejects-authentication` you need to manually visit this URL in your browser:
```
https://aes.keycloak-fapi.org/automated/ciba/approval?auth_req_id=foo&action=deny
```
This tells CIBA authentication entity server that further authentication attempts should be denied, which is 
expected by this test.
2.b) After this test is executed, you need to visit back this URL:
```
https://aes.keycloak-fapi.org/automated/ciba/approval?auth_req_id=foo&action=allow
```
to make sure that further requests to the CIBA authentication server will be allowed.

### Run FAPI Conformance test plan manually against the online conformance testsuite

To obtain the certification, it is needed to run the conformance testsuite against the online production instance available on
https://www.certification.openid.net/ . You can still use the Keycloak server, Resource server and other utilities provided by this project
to help setup the environment needed for the conformance testsuite.

The configuration assumes that your laptop, where you are running the instance, is accessible through the internet, so that clients used
by conformance testsuite can connect to it. Simple setup assumes that your server is accessible for example on `85-244-72-90.nip.io` and
you have 2 ports opened:
  * Port 543 where Keycloak server will listen. So URL of Keycloak might be like https://85-244-72-90.nip.io:543/auth
  * Port 443 where Resource server will listen. So URL of Resource server might be like https://85-244-72-90.nip.io:443
If you use different ports, please adjust your haproxy configuration for the frontends under `load-balancer/haproxy_two-frontends.cfg`.  

The setup for this scenario is like:

1. Setup environment variables something like this. It assumes that 85.244.72.90 is your public IP and the 192.168.0.101 is the IP
of your laptop in the private local network. The introspection endpoint, which is triggered by the resource server, needs to call
Keycloak server under this private network. At least in my environment the access through public network did not work. But this 
can be environment specific. During troubles with calling introspection endpoint, you can later try to connect to api-gateway-nginx
docker container and verify with `curl` command what servers are accessible from this container.
So adjust your configuration according your environment if needed:
```
export AUTOMATE_TESTS=false
export KEYCLOAK_FQDN=85-244-72-90.nip.io
export KEYCLOAK_FRONTEND_URL=https://85-244-72-90.nip.io:543/auth
export KEYCLOAK_INTROSPECTION_ENDPOINT_FROM_API_GATEWAY=https://192-168-0-101.nip.io:543/auth/realms/test/protocol/openid-connect/token/introspect
export RESOURCE_FQDN=84-244-72-90.nip.io
```    
2. Re-generate server certificates to match the hostnames of your environment. You can use command like this and possibly change the second host according your laptop address:
```
https/generate-server.sh $KEYCLOAK_FQDN 192-168-0-101.nip.io
```
3. In case you use local built Keycloak instance as described below, it is recommended to delete the Keycloak directory and unzip new directory
to make sure that certificates from previous step will be correctly copied to the server. Also make sure that customizations for CIBA and
well-known endpoint are manually done since you use your own Docker volume (See [Keycloak dockerfile](./keycloak/Dockerfile) for the details)
4. It is needed to comment the RESOURCE_FQDN in the `docker-compose.yml` file in the load_balancer network section. Something like this:
```
networks:
  default:
    aliases:
     - ${KEYCLOAK_FQDN}
     #  - ${RESOURCE_FQDN}
     - ${CONFORMANCE_SUITE_FQDN}
```
5. In the `loadbalancer/Dockerfile`, it may be needed to switch the configuration file of the loadbalancer. Something like this:
```
# RUN /bin/sh -c "cp /tmp/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg"
RUN /bin/sh -c "cp /tmp/haproxy_two-frontends.cfg /usr/local/etc/haproxy/haproxy.cfg"
```
6. If you manually run CIBA tests, some manual changes are needed in the `auth_entity_server/main.go` to change the server name.
Especially it is needed to change the ServerName in TLS Client Config to use IP of your laptop, which can be accessed from the local network. Something like this:
```
ServerName:         "192-168-0-101.nip.io",
```
Same applies for the URL of the Keycloak Backchannel Authentication Callback Endpoint, which may also need to be changed to something like this:
```
u := "https://192-168-0-101.nip.io:543/auth/realms/test/protocol/openid-connect/ext/ciba/auth/callback/"
```
7. Rebuild and restart whole docker-compose environment as described above.
8. Follow the steps for the `Run FAPI Conformance test plan manually` described above. With the exception, that:
  * You need to use online instance of the conformance testsuite from https://www.certification.openid.net/
  * After importing the client configurations from the `fapi-conformance-suite-configs` directory, you may need to replace the URLs of
  the keycloak server like using `as.keycloak-fapi.org` with your publicly available Keycloak instance like `https://85-244-72-90.nip.io:543/auth/...`.
  Same applies for the resource server URL, which is `rs.keycloak-fapi.org` in the configuration files by default, and needs to be replaced with your publicly available one.
  And finally you need to remove the line with the URL of the CIBA approval endpoint (`automated_ciba_approval_url`) in case of the CIBA tests.
  The automated approval does not work with automated tests due the test `fapi-ciba-id1-ensure-authorization-request-with-potentially-bad-binding-message`,
  which requires screenshot of the binding message being sent. Also you need to manually visit URLs during the test
  as describe above in the section `Run FAPI CIBA Conformance test plan manually`
9. In case you test with CIBA Ping mode, you need to login to Keycloak admin console before the test and manually change the
property `CIBA Backchannel Client Notification Endpoint` of the following clients (in case you use PS256 algorithm):
```
client1-mtls-PS256-PS256-fapi-ciba-ping-id1
client1-private_key_jwt-PS256-PS256-fapi-ciba-ping-id1
client2-mtls-PS256-PS256-fapi-ciba-ping-id1
client2-private_key_jwt-PS256-PS256-fapi-ciba-ping-id1
```
to the URL of certification testsuite itself, which is something like `https://www.certification.openid.net/test/a/keycloak/ciba-notification-endpoint`.
See the instructions for additional details: https://openid.net/certification/fapi_ciba_op_testing/ 

## For Developers

**Currently, generators of all configurations are written with bash script and some CLI tools for linux-amd64.**

Run `generate-all.sh` script simply to generate self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.

```
./generate-all.sh
```

Now, you can boot a Keycloak server with new configurations.

```
docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --force-recreate
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

Then run the FAPI Conformance Suite with KEYCLOAK_REALM_IMPORT_FILENAME env var:

```
KEYCLOAK_REALM_IMPORT_FILENAME=realm-local.json docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build
```

## Run FAPI Conformance test with persistent OpenID Server DB volume

Running this test suite does not require a persistent storage volume for MongoDB. The main benefit of
using persistent volume storage is that the OpenID Conformance Suite will remember the last test plan
config you used, allowing for easier and faster manual test operation. If you wish to enable persistent volume storage for the MongoDB container, uncomment 
the following lines in ./docker-compose.yml

```
...
#    volumes:
#     - mongodata:/data/db
...
#volumes:
#  mongodata:
```

## Custom files in the conformance suite

The conformance-suite folder within this repository is a local copy of OpenIds FAPI conformance suite (https://gitlab.com/openid/conformance-suite/).
Incorporating the suite and running the conformance tests within docker-compose requires adding custom files into the base OpenId FAPI conformance suite.
Below is a list of the custom files currently used by the base conformance-suite.
* /conformance-suite/run-tests.sh
  * Script for running / creating test plans
* /conformance-suite/Dockerfile
  * Dockerfile which installs python dependencies, exposes ports and kicks off building the project via the server-entrypoint script 
* /conformance-suite/server-entrypoint.sh
  * Script for building the project with maven

## Run specified FAPI Conformance test

You can choose and run automatically several types of FAPI conformance test against both released keycloak container from quay.io or one you've installed on your local environment.

To do so, you need to set to the environment variable `TEST_PLAN` the value shown in the following table.

**Certified Financial-grade API (FAPI) OpenID Providers**

**Financial-grade API (FAPI) 1.0 Final**

**FAPI 1 Advanced Final (Generic)**

|Conformance Profile|Test Plan|client_auth_type|fapi_profile|fapi_response_mode|fapi_auth_request_method|TEST_PLAN|
|-------------------|---------|----------------|------------|------------------|------------------------|---------|
|FAPI Adv. OP w/ Private Key|fapi1-advanced-final-test-plan|private_key_jwt|plain_fapi|plain_response|by_value|--fapi1-advanced|
|FAPI Adv. OP w/ MTLS|fapi1-advanced-final-test-plan|mtls|plain_fapi|plain_response|by_value|--fapi1-advanced|
|FAPI Adv. OP w/ Private Key, PAR|fapi1-advanced-final-test-plan|private_key_jwt|plain_fapi|plain_response|pushed|--fapi1-advanced-par|
|FAPI Adv. OP w/ MTLS, PAR|fapi1-advanced-final-test-plan|mtls|plain_fapi|plain_response|pushed|--fapi1-advanced-par|
|FAPI Adv. OP w/ Private Key, JARM|fapi1-advanced-final-test-plan|private_key_jwt|plain_fapi|jarm|by_value|--fapi1-advanced-jarm|
|FAPI Adv. OP w/ MTLS, JARM|fapi1-advanced-final-test-plan|mtls|plain_fapi|jarm|by_value|--fapi1-advanced-jarm|
|FAPI Adv. OP w/ Private Key, PAR, JARM|fapi1-advanced-final-test-plan|private_key_jwt|plain_fapi|jarm|pushed|--fapi1-advanced-par-jarm|
|FAPI Adv. OP w/ MTLS, PAR, JARM|fapi1-advanced-final-test-plan|mtls|plain_fapi|jarm|pushed|--fapi1-advanced-par-jarm|


**Certified Financial-grade API Client Initiated Backchannel Authentication Profile (FAPI-CIBA) OpenID Providers**

|Conformance Profile|Test Plan|client_auth_type|fapi_profile|ciba_mode|client_registration|TEST_PLAN|
|-------------------|---------|----------------|------------|---------|-------------------|---------|
|FAPI-CIBA OP poll w/ Private Key|fapi-ciba-id1-test-plan|private_key_jwt|plain_fapi|poll|static_client|--fapi-ciba-poll-id1|
|FAPI-CIBA OP poll w/ MTLS|fapi-ciba-id1-test-plan|mtls|plain_fapi|poll|static_client|--fapi-ciba-poll-id1|
|FAPI-CIBA OP ping w/ Private Key|fapi-ciba-id1-test-plan|private_key_jwt|plain_fapi|ping|static_client|--fapi-ciba-ping-id1|
|FAPI-CIBA OP ping w/ MTLS|fapi-ciba-id1-test-plan|mtls|plain_fapi|ping|static_client|--fapi-ciba-ping-id1|

**Brazil Open Banking (Based on FAPI 1 Advanced Final)**

|Conformance Profile|Test Plan|client_auth_type|fapi_profile|fapi_response_mode|fapi_auth_request_method|TEST_PLAN|
|-------------------|---------|----------------|------------|------------------|------------------------|---------|
|BR-OB Adv. OP w/ Private Key|fapi1-advanced-final-test-plan|private_key_jwt|openbanking_brazil|plain_response|by_value|--ob-br-fapi1-advanced|
|BR-OB Adv. OP w/ MTLS|fapi1-advanced-final-test-plan|mtls|openbanking_brazil|plain_response|by_value|--ob-br-fapi1-advanced|
|BR-OB Adv. OP w/ Private Key, PAR|fapi1-advanced-final-test-plan|private_key_jwt|openbanking_brazil|plain_response|pushed|--ob-br-fapi1-advanced-par|
|BR-OB Adv. OP w/ MTLS, PAR|fapi1-advanced-final-test-plan|mtls|openbanking_brazil|plain_response|pushed|--ob-br-fapi1-advanced-par|
|BR-OB Adv. OP w/ Private Key, JARM|fapi1-advanced-final-test-plan|private_key_jwt|openbanking_brazil|jarm|by_value|--ob-br-fapi1-advanced-jarm|
|BR-OB Adv. OP w/ MTLS, JARM|fapi1-advanced-final-test-plan|mtls|openbanking_brazil|jarm|by_value|--ob-br-fapi1-advanced-jarm|
|BR-OB Adv. OP w/ Private Key, PAR, JARM|fapi1-advanced-final-test-plan|private_key_jwt|openbanking_brazil|jarm|pushed|--ob-br-fapi1-advanced-par-jarm|
|BR-OB Adv. OP w/ MTLS, PAR, JARM|fapi1-advanced-final-test-plan|mtls|openbanking_brazil|jarm|pushed|--ob-br-fapi1-advanced-par-jarm|

**Certified OpenID Providers**

|Conformance Profile|Test Plan|server_metadata|client_registration|response_type|TEST_PLAN|
|-------------------|---------|---------------|-------------------|-------------|---------|
|Config OP|oidcc-config-certification-test-plan|-|-|-|--oidcc-config|
|Basic OP|oidcc-basic-certification-test-plan|discovery|static_client|-|--oidcc-basic|
|Basic OP|oidcc-basic-certification-test-plan|discovery|dynamic_client|-|--oidcc-basic|
|Basic OP|oidcc-basic-certification-test-plan|static|static_client|-|--oidcc-basic|
|Implicit OP|oidcc-implicit-certification-test-plan|discovery|static_client|-|--oidcc-implicit|
|Implicit OP|oidcc-implicit-certification-test-plan|discovery|dynamic_client|-|--oidcc-implicit|
|Implicit OP|oidcc-implicit-certification-test-plan|static|static_client|-|--oidcc-implicit|
|Hybrid OP|oidcc-hybrid-certification-test-plan|discovery|static_client|-|--oidcc-hybrid|
|Form Post OP|oidcc-basic-certification-test-plan|discovery|static_client|-|--oidcc-formpost-basic|
|Form Post OP|oidcc-implicit-certification-test-plan|discovery|static_client|-|--oidcc-formpost-implicit|
|Form Post OP|oidcc-hybrid-certification-test-plan|discovery|static_client|-|--oidcc-formpost-hybrid|
|Form Post OP|oidcc-[basic, implicit, hybrid]-certification-test-plan|discovery|static_client|-|--oidcc-formpost|
|Dynamic OP|oidcc-dynamic-certification-test-plan|-|-|code idtoken|--oidcc-dynamic|
|3rd Party-Init OP|oidcc-3rdparty-init-login-certification-test-plan|-|-|code idtoken|--oidcc-3rdparty-init-login|

Note: If you run OpenID Provider conformance tests, please use `realm-oidc.json` realm setting file like:
```
KEYCLOAK_REALM_IMPORT_FILENAME=realm-oidc.json docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build
```

Eg. The following command runs `FAPI Adv. OP w/ Private Key, PAR, JARM` and `FAPI Adv. OP w/ MTLS, PAR, JARM` conformance test.
```
TEST_PLAN=--fapi1-advanced-par-jarm docker-compose -p keycloak-fapi -f docker-compose.yml -f docker-compose-keycloak.yml up --build
```

If you set `--server-tests-only` to `TEST_PLAN`, it runs all types of FAPI conformance tests shown above the table automatically.

If you set `--fapi1-advanced-all` to `TEST_PLAN`, it runs all types of FAPI 1 Advanced Final (Generic) conformance tests shown above the table automatically.

If you set `--fapi-ciba-all` to `TEST_PLAN`, it runs all types of FAPI-CIBA OpenID Providers conformance tests shown above the table automatically.

If you set `--ob-br-fapi1-advanced-all` to `TEST_PLAN`, it runs all types of Brazil Open Banking (Based on FAPI 1 Advanced Final) conformance tests shown above the table automatically.

If you set `--oidcc-all` to `TEST_PLAN`, it runs all types of OpenID Provider conformance tests shown above the table automatically.

If you set nothing to `TEST_PLAN`, it runs FAPI conformance tests the same as set `--fapi1-advanced-all`.

### Notes

#### Overlay with locally installed keycloak

On building container image of keycloak, CIBA settings are applied to keycloak (standalone-ha.xml). It means that these CIBA settings do not work when using locally build keycloak because these CIBA settings are applied to containerized keycloak, not locally installed keycloak.

To get around this issue, modules and themes of containerized keycloak are overlaid with ones of locally built keycloak by modifying docker-compose.yml as follows.

```
@@ -28,6 +28,7 @@ services:
      - ./https/server.pem:/etc/x509/https/tls.crt
      - ./https/server-key.pem:/etc/x509/https/tls.key
      - ./https/client-ca.pem:/etc/x509/https/client-ca.crt
+     - <top directory path to locally built keycloak>/modules:/opt/jboss/keycloak/modules
+     - <top directory path to locally built keycloak>/modules:/opt/jboss/keycloak/themes:/opt/jboss/keycloak/themes
     ports:
      - "8787:8787"
     environment:
```

#### Not passed tests automatically

Due to the nature of conformance suite, the following tests cannot be passed automatically. After completion of automatic tests, you can run them manually and confirm they are passed.

  * fapi1-advanced-final-par-attempt-reuse-request_uri
  * fapi1-advanced-final-par-pushed-authorization-url-as-audience-in-request-object
  * fapi-ciba-id1-ensure-authorization-request-with-potentially-bad-binding-message :
 This always become `reviewed` status in automated tests if the server supports binding messages containing emoji etc - it requires uploading a picture of the consumption device to conformance test server.

  * oidcc-server-rotate-keys
 This always become `failure` status in automated tests. However, we can pass this test manually by createing a new key in sigature and disabling the exsiting key (RS256) in signature on an admin console.

**Running different test plans**

To create custom test plans, add code into /conformance-suite/run-tests.sh as per commented out examples.
JSON configuration files for test plans should be created in /conformance-suite/.gitlab-ci/

## License

* [Apache License, Version 2.0](./LICENSE)

