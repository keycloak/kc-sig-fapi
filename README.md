# keycloak-fapi

The purpose of this project is to run [Conformance Testing for FAPI Read/Write OPs](https://openid.net/certification/fapi_op_testing/) with Keycloak server, find issues and improve them.
The final goal is, of course, to receive official FAPI OpenID Provider Certifications.

## How to run FAPI Conformance suite with Keycloak server in your local machine

### Software requirements

* [Docker CE](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* JDK and [Maven](https://maven.apache.org/)

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

Then, build the server using Maven.

```
> cd conformance-suite
> mvn clean package
```

Finally, boot all the containers using Docker Compose.

**Note: We need to set the environment variable `FINTECHLABS_BASE_URL` to change from `https://localhost:8443`** 

```
> export FINTECHLABS_BASE_URL=https://conformance-suite.keycloak-fapi.org
> docker-compose up
```

### Run Local Keycloak server

This repository contains default self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs. If you would like to use the configurations as it is, you only need to build a container image and run it.

```
> docker build -t keycloak-fapi .
...
Successfully tagged keycloak-fapi:latest
```

Then, boot all the containers using Docker Compose.

```
> docker-compose up
```

### Modify your `hosts` file

To access using FQDN, modify your `hosts` file in your local machine as follow.

```
127.0.0.1 as.keycloak-fapi.org rs.keycloak-fapi.org conformance-suite.keycloak-fapi.org
```

### Run FAPI Conformance test plan

1. Open https://conformance-suite.keycloak-fapi.org
2. Choose **FAPI-RW-ID2: with private key and mtls holder of key Test Plan** in test plans
3. Click `JSON` tab and paste content of [fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json](./fapi-conformance-suite-configs/fapi-rw-id2-with-private-key-RS256-PS256.json).
4. Click `Start Test Plan` button and follow the instructions. To proceed with the tests, You can authenticate using `john` account with password `john`.

**Note: There is a known issue when using PS256/ES256 as request object signature alg. To proceed with all the test cases, we need to use RS256 instead of them currently.**


## How to deploy the servers on the internet

In you would like to deploy on the internet, follow below instructions.
We will use Amazon Linux 2 on Amazaon EC2 as an example.

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

Fetch sources.

```
git clone https://gitlab.com/openid/conformance-suite.git
git clone https://github.com/jsoss-sig/keycloak-fapi.git
```

Export environment variables with your FQDN.

```
export KEYCLOAK_FQDN=as.keycloak-fapi.org
export RESOURCE_FQDN=rs.keycloak-fapi.org
export CONFORMANCE_SUITE_FQDN=conformance-suite.keycloak-fapi.org
```

Build FAPI Conformance suite and boot the containers using Docker Compose.

```
cd conformance-suite
mvn clean package
export FINTECHLABS_BASE_URL=https://$CONFORMANCE_SUITE_FQDN
docker-compose up -d
```

Generate server certificates, Keycloak realm config and FAPI Conformance suite configs with your FQDN.

```
cd ../keycloak-fapi
./https/generate-server.sh $KEYCLOAK_FQDN $RESOURCE_FQDN
./keycloak/generate-realm.sh $CONFORMANCE_SUITE_FQDN
./fapi-conformance-suite-configs/generate-fapi-conformance-suite-configs.sh $KEYCLOAK_FQDN $RESOURCE_FQDN
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

