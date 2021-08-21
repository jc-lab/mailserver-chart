#!/bin/bash

set -eu

. /opt/common.sh

TEMP_SECRET_DKIM_DIR=/tmp-dkim-secret

# Environment Variables
# - DKIM_SELECTOR
# - MYDOMAIN
# - POSTMASTER_ADDRESS

DKIM_SELECTOR_FROM_FILE=$(cat /secret-dkim/selector || echo "")
DKIM_SELECTOR=${DKIM_SELECTOR:-${DKIM_SELECTOR_FROM_FILE}}

cat > /etc/opendkim/opendkim.conf <<EOF
BaseDirectory           /run/opendkim
#LogWhy                 yes
Syslog                  no
SyslogSuccess           yes
Canonicalization        relaxed/simple
Domain                  ${MYDOMAIN}
Selector                ${DKIM_SELECTOR}
KeyFile                 ${TEMP_SECRET_DKIM_DIR}/current.key
Socket                  inet:8891@localhost
#Socket                 local:opendkim.sock
ReportAddress           ${POSTMASTER_ADDRESS}
SendReports             yes
## Hosts to sign email for - 127.0.0.1 is default
## See the OPERATION section of opendkim(8) for more information
#
# InternalHosts         192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12
## For secondary mailservers - indicates not to sign or verify messages
## from these hosts
#
# PeerList                 X.X.X.X
PidFile                  /var/run/opendkim/opendkim.pid
#KeyTable                /etc/opendkim/KeyTable
#SigningTable            /etc/opendkim/SigningTable
#ExternalIgnoreList      /etc/opendkim/TrustedHosts
#InternalHosts           /etc/opendkim/TrustedHosts
EOF

mkdir -p /run/opendkim ${TEMP_SECRET_DKIM_DIR}
cp /secret-dkim/${DKIM_SELECTOR}.key ${TEMP_SECRET_DKIM_DIR}/current.key
chown root.opendkim -R ${TEMP_SECRET_DKIM_DIR}
chmod 750 ${TEMP_SECRET_DKIM_DIR}
chmod 440 ${TEMP_SECRET_DKIM_DIR}/current.key

exec "$@"

