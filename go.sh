#!/bin/bash

set -e

(cd image && docker build --tag=localhost:32000/temp-mailserver:test .)
docker push localhost:32000/temp-mailserver:test
# (cd chart && microk8s.helm3 install mailserver . -f values.yaml)
(cd chart && microk8s.helm3 upgrade mailserver . -f values.yaml || microk8s.helm3 install mailserver . -f values.yaml)


