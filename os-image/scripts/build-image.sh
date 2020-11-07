#!/usr/bin/env bash

set -e

# Set trap to log error in case of script failure.
echo "🏗  Building image..."
trap 'echo "🛑 Failed to build image."' ERR

: "${AUTHORIZED_KEYS_B64:?"You must provide base64-encoded public SSH keys to put on the Raspberry Pi."}"
: "${PI_HOSTNAME:?"You must provide a hostname for your Raspberry Pi."}"
: "${PI_USERNAME:?"You must provide a username to create and configure."}"
: "${WIFI_PASSWORD:?"You must provide the WiFi network's password."}"
: "${WIFI_SSID:?"You must provide a WiFi network to configure."}"

# Run Packer.
echo "  ⏳ Running Packer..."
(
  cd /vagrant
  sudo packer build \
    -var pi_hostname="${PI_HOSTNAME}" \
    -var pi_username="${PI_USERNAME}" \
    -var authorized_keys_b64="${AUTHORIZED_KEYS_B64}" \
    -var wifi_password="${WIFI_PASSWORD}" \
    -var wifi_ssid="${WIFI_SSID}" \
    packer/raspios.pkr.hcl
)
echo "  👍 Packer run."

echo "🚀 Image built!"
