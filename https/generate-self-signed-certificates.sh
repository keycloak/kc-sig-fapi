#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

# Install cfssl
mkdir -p .bin
curl -s -L -o .bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o .bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x .bin/{cfssl,cfssljson}
PATH=$PATH:.bin

# Generate
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server-csr.json | cfssljson -bare server
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client1-csr.json | cfssljson -bare client1
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client2-csr.json | cfssljson -bare client2

# Verify
openssl x509 -in ca.pem -text -noout
openssl x509 -in server.pem -text -noout
openssl x509 -in client1.pem -text -noout
openssl x509 -in client2.pem -text -noout

