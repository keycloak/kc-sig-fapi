# keycloak-fapi

The purpose of this project is to run [Conformance Testing for FAPI Read/Write OPs](https://openid.net/certification/fapi_op_testing/) with Keycloak server, find issues and improve them.
The final goal is, of course, to receive official FAPI OpenID Provider Certifications.

## How to run FAPI Conformance suite with Keycloak server in your local machine.

### Software requirements

* [Docker CE](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/)

### Run FAPI Conformance suite server

Clone [FAPI Conformance suite repository](https://gitlab.com/openid/conformance-suite).

```
> git clone https://gitlab.com/openid/conformance-suite.git
```

If you would like to run the server on Docker for Windows, change `volumes` in `docker-compose.yml` as follows. 

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

Then, build & boot all the containers.

```
> docker-compose up
```

Once booted, stop all containers by `CTRL + c`. 
Then get the gateway address in the docker network which is created when initial boot.

```
> docker network inspect conformance-suite_default | grep Gateway
                    "Gateway": "172.18.0.1"
```

Then add the gateway address as `extra_hosts` with your local keycloak server FQDN into `docker-compose.yml`. This configuration is needed to access from FAPI Conformance suite server to your local keycloak server's endpoints such as token endpoint request and resource request.

```
   server:
     build:
       context: ./server-dev
     volumes:
      - ./target/:/server/
     command: java -jar /server/fapi-test-suite.jar --fintechlabs.devmode=true --fintechlabs.startredir=true
     links:
      - mongodb:mongodb
      - microauth:microauth
+    extra_hosts:
+     - "keycloak-fapi.org:172.18.0.1"
     depends_on:
      - mongodb
     logging:
```

Finally, boot all the containers again.

```
> docker-compose up
```

### Run Local Keycloak server

This repository contains default self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs. If you would like to use the configurations as it is, you only need to build a container image and run it.

```
> docker build -t keycloak-fapi .
...
Successfully tagged keycloak-fapi:latest
> docker run --rm -it -p 10443:10443 -p 9443:9443 \
    -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin \
    keycloak-fapi -b 0.0.0.0 -Djboss.socket.binding.port-offset=1000
```

* **Note1: You need to set `-Djboss.socket.binding.port-offset=1000` option to use 9443 port for TLS in Keycloak server because FAPI Conformance suite server uses 8443 port.**
* **Note2: You need to expose 10443 port for Resource Server.**

Also, modify your `hosts` file in your local machine as follow.

```
127.0.0.1 keycloak-fapi.org
```

### Run FAPI Conformance test plan

1. Open https://localhost:8443
2. Choose **FAPI-RW-ID2: with private key and mtls holder of key Test Plan** in test plans
3. Click `JSON` tab and paste content of [fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json).
4. Click `Start Test Plan` button and follow the instructions. To proceed with the tests, You can authenticate using `john` account with password 'john'.

**Note: There is a known issue when using PS256/ES256 as request object signature alg. To proceed with all the test cases, we need to use RS256 instead of them currently.**


## For Developers

**Currently, generators of all configurations are written with bash script and some CLI tools for linux-amd64.**

Run `generate-all.sh` script simply to generate self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.

```
> ./generate-all.sh
```

Then build a docker container image.

```
> docker build -t keycloak-fapi .
```

Now, you can boot a Keyclaok server with new configurations.

```
> docker run --rm -it -p 8787:8787 -p 10443:10443 -p 9443:9443 \
    -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin \
    keycloak-fapi -b 0.0.0.0 -Djboss.socket.binding.port-offset=1000 --debug
```

## License

* [Apache License, Version 2.0](./LICENSE)

