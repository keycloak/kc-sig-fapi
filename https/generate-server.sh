#!/bin/bash

# ARG1: Hostname of Keycloak server
# ARG2: Hostname of Resource server
KC_HOST=${1:-as.keycloak-fapi.org}
RS_HOST=${2:-rs.keycloak-fapi.org}

DIR=$(cd $(dirname $0); pwd)
cd $DIR

type cfssl
if [ $? -ne 0 ]; then
    type .bin/cfssl
    if [ $? -ne 0 ]; then
        # Install cfssl
        mkdir -p .bin
        curl -s -L -o .bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
        curl -s -L -o .bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
        chmod +x .bin/{cfssl,cfssljson}
    fi
    PATH=$PATH:.bin
fi

cat << EOS > server-csr.json
{
    "CN": "secureoss.jp",
    "hosts": [
        "127.0.0.1",
        "localhost",
        "*.secureoss.jp",
        "keycloak.org",
        "*.keycloak.org",
        "$KC_HOST",
        "$RS_HOST"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "JP",
            "L": "",
            "O": "Secure OSS Sig",
            "OU": "Keycloak-fapi",
            "ST": "Server"
        }
    ]
}
EOS

# Generate
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server-csr.json | cfssljson -bare server

# Verify
openssl x509 -in ca.pem -text -noout
openssl x509 -in server.pem -text -noout

