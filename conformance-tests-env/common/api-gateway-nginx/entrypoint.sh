#!/bin/sh

CONF_DIR=/usr/local/openresty/nginx/conf
envsubst '$SERVER_NAME $SERVER2_NAME' < $CONF_DIR/nginx.conf.template > $CONF_DIR/nginx.conf && cat $CONF_DIR/nginx.conf

update-ca-certificates

nginx -g 'daemon off;'
