#!/bin/bash

for i in *.rpm; do
  echo "Uploading $i"
  curl --progress-meter -u __token__:$(vault -l packages.nitor.zone.apikey) --upload-file $i https://packages.nitor.zone/repository/yum/intune/$i
done