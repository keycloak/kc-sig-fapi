# keycloak-fapi


## How to run FAPI Conformance suite with Keycloak

TODO

## For Developers

**Currently, generators of all configurations are written with bash script and some CLI tools for linux-amd64.**

Run `generate-all.sh` script simply to genrate self-signed certificates for HTTPS, client private keys, Keycloak Realm JSON and FAPI Conformance suite config JSONs.

```
./generate-all.sh
```

Then build docker container image.

```
docker build -t keycloak-fapi .
```

Now, you can boot a Keyclaok server for the testing.

**Note: You need to set `-Djboss.socket.binding.port-offset=1000` option to use 10443 port for TLS in Keycloak server.**

```
docker run --rm -it -p 8787:8787 -p 10443:10443 -p 9443:9443 \
    -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin \
    keycloak-fapi -b 0.0.0.0 -Djboss.socket.binding.port-offset=1000 --debug
```

## License

* [Apache License, Version 2.0](./LICENSE)

