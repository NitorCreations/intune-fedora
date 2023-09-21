#!/bin/bash

set -e -o pipefail

podman build . | tee build.log

ID=$(tail -n 1 build.log)

rm -rf tmp && mkdir tmp
cd tmp

echo "Extracting rpms from image..."
podman image save $ID | tar xf - --wildcards '*.tar'
for i in */layer.tar; do
  tar xvf $i --wildcards '*.rpm' 2> /dev/null || true
done

mv *.rpm ..
cd ..
rm -rf tmp

## anyone can figure out how to fix curl dependency inside inttune-portal.rpm?
# nothing provides libcurl.so.4(CURL_OPENSSL_4)(64bit) needed by intune-portal

echo
echo "Install packages using:"
echo
echo "sudo rpm -Uvh --nodeps " intune-portal-*.rpm
echo "sudo dnf install " msalsdk-dbusclient*.rpm microsoft-identity-broker-*.rpm

