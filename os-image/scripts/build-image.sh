#!/usr/bin/env bash

set -e

# Set trap to log error in case of script failure.
echo "🏗  Building image..."
trap 'echo "🛑 Failed to build image."' ERR

: ${WIFI_SSID:?"You must provide a WiFi network to configure."}
: ${WIFI_PASSWORD:?"You must provide the WiFi network's password."}
: ${PI_HOSTNAME:?"You must provide a hostname for your Raspberry Pi."}
: ${PI_USERNAME:?"You must provide a username to create and configure."}

# Run Packer.
PACKER_VERSION="1.6.4"
echo "  ⏳ Running Packer..."
(
  cd /vagrant
  sudo packer build \
    -var wifi_ssid="${WIFI_SSID}" \
    -var wifi_password="${WIFI_PASSWORD}" \
    -var pi_hostname="${PI_HOSTNAME}" \
    -var pi_username="${PI_USERNAME}" \
    packer/raspios.pkr.hcl
)
echo "  👍 Packer run."

echo "🚀 Image built!"
