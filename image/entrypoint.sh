#!/bin/bash

mkdir -p /run/opendkim /run/postfix-private-auth

rm -rf /var/spool/postfix/private/auth || true
ln -s /run/postfix-private-auth /var/spool/postfix/private/auth

exec "$@"

