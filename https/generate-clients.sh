#!/bin/bash

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

# Generate
cfssl gencert -initca client-ca-csr.json | cfssljson -bare client-ca
cfssl gencert -ca=client-ca.pem -ca-key=client-ca-key.pem -config=ca-config.json -profile=client client1-csr.json | cfssljson -bare client1
cfssl gencert -ca=client-ca.pem -ca-key=client-ca-key.pem -config=ca-config.json -profile=client client2-csr.json | cfssljson -bare client2

# Verify
openssl x509 -in client-ca.pem -text -noout
openssl x509 -in client1.pem -text -noout
openssl x509 -in client2.pem -text -noout

