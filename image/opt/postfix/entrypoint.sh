#!/bin/bash

set -eu

. /opt/common.sh

CONFIG_DIR=/config
SECURE_CONFIG_DIR=/secure-config

eval "echo \"`cat ${CONFIG_DIR}/main.cf`\"" > /etc/postfix/main.cf
eval "echo \"`cat ${CONFIG_DIR}/master.cf`\"" > /etc/postfix/master.cf

for name in $(cd ${CONFIG_DIR} && find -maxdepth 1 ! -type d | grep -v -E '\.\.data|main\.cf|master\.cf'); do
  dest_file=/etc/postfix/$(echo "$name" | sed -e 's:__:/:g')
  dest_dir=$(dirname "${dest_file}")
  mkdir -p ${dest_dir}
  cp "${CONFIG_DIR}/${name}" "${dest_file}"
done

for name in $(cd ${SECURE_CONFIG_DIR} && find -maxdepth 1 ! -type d | grep -v -E '\.\.data'); do
  dest_file=/etc/postfix/$(echo "$name" | sed -e 's:__:/:g')
  dest_dir=$(dirname "${dest_file}")
  mkdir -p ${dest_dir}
  cp "${SECURE_CONFIG_DIR}/${name}" "${dest_file}"
done


exec "$@"

