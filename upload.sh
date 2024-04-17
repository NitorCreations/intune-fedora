#!/bin/bash

local token="$(vault -l packages.nitor.zone.apikey)"
for i in *.rpm; do
  echo "Uploading $i"
  curl --progress-meter -u __token__:"$token" --upload-file $i https://packages.nitor.zone/repository/yum/intune/$i
done
