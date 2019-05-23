# keycloak-fapi

The purpose of this project is to run [Conformance Testing for FAPI Read/Write OPs](https://openid.net/certification/fapi_op_testing/) with Keycloak server, find issues and improve them.
The final goal is, of course, to receive official FAPI OpenID Provider Certifications.

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
2. Choose **FAPI-RW-ID2: with private key and mtls holder of key Test Plan** in test plans
3. Click `JSON` tab and paste content of [fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json).
4. Click `Start Test Plan` button and follow the instructions. To proceed with the tests, You can authenticate using `john` account with password `john`.

**Note: There is a known issue when using PS256/ES256 as request object signature alg. To proceed with all the test cases, we need to use RS256 instead of them currently.**


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


## License

* [Apache License, Version 2.0](./LICENSE)

