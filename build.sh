#!/bin/bash

set -e -o pipefail

rm -f *.rpm

if command -v podman >/dev/null; then
  PODMAN=podman
elif command -v docker >/dev/null; then
  PODMAN=docker
else
  echo "No container runtime found"
  exit 1
fi

$PODMAN build . 2>&1 | tee build.log

if [ $PODMAN = podman ]; then
  ID=$(tail -n 1 build.log)
else
  ID=$(grep "writing image" build.log | awk -NF " |:" '{ print $5 }')
fi

rm -rf tmp && mkdir tmp
cd tmp

echo "Extracting rpms from image..."
if [ $PODMAN = podman ]; then
  $PODMAN image save $ID | tar xf - --wildcards '*.tar'
  for i in */layer.tar; do
    tar xvf $i --wildcards '*.rpm' 2> /dev/null || true
  done
else
  $PODMAN image save $ID | tar xf -
  for i in $(find blobs -type f); do
    tar -xvf $i --wildcards '*.rpm' 2> /dev/null || true
  done
fi

mv *.rpm ..
cd ..
rm -rf tmp

echo
echo "Install packages by running:"
echo
echo "./install.sh"
