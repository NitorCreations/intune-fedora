#!/bin/bash

sudo dnf install webkit2gtk4.0
sudo dnf install intune-portal-*.rpm msalsdk-dbusclient*.rpm microsoft-identity-broker-*.rpm

systemctl --user enable /lib/systemd/user/intune-agent.timer

if [ ! -f /etc/yum.repos.d/microsoft-edge.repo ]; then
  cat << EOF | sudo tee /etc/yum.repos.d/microsoft-edge.repo
[microsoft-edge]
name=microsoft-edge
baseurl=https://packages.microsoft.com/yumrepos/edge/
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi
sudo dnf install microsoft-edge-beta

echo "You need to restart your machine for changes to apply"
