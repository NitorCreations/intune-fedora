#!/bin/bash

sudo dnf install webkit2gtk4.0
sudo rpm -Uvh --nodeps intune-portal-*.rpm
sudo dnf install msalsdk-dbusclient*.rpm microsoft-identity-broker-*.rpm

systemctl --user enable /lib/systemd/user/intune-agent.timer

echo "You need to restart your machine for changes to apply"
