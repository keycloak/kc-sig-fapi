#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

type jwk-keygen
if [ $? -ne 0 ]; then
    # Install jwk-keygen
    mkdir -p .bin
    curl -s -L https://github.com/openstandia/jwk-keygen/releases/download/v0.1/jwk-keygen-v0.1-linux-amd64.tar.gz | tar zx -C .bin
    PATH=$PATH:.bin
fi

rm -f *.json
rm -f *.pem

jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=PS256 --kid=client1-PS256
jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=PS256 --kid=client2-PS256
jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=ES256 --kid=client1-ES256
jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=ES256 --kid=client2-ES256
jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=RS256 --kid=client1-RS256
jwk-keygen --use=sig --format --jwks --pem --pem-body --alg=RS256 --kid=client2-RS256

