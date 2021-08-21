#!/bin/bash

if [ ! -e /run/postfix-private ]; then
  mv /var/spool/postfix/private /run/postfix-private || true
fi
rm -rf /var/spool/postfix/private
ln -s /run/postfix-private /var/spool/postfix/private

