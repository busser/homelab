#!/usr/bin/env bash

set -e

# Set trap to log error in case of script failure.
echo "🏭  Setting up build environment..."
trap 'echo "🛑 Failed to set up build environment."' ERR

# Install required packages.
echo "  📦 Installing required packages..."
sudo apt-get update -qq
sudo apt-get install -qq -y \
  kpartx \
  qemu-user-static \
  git \
  wget \
  curl \
  vim \
  unzip \
  gcc

# Install Go.
GO_VERSION="1.15.3"
echo "  🐹 Installing Go ${GO_VERSION}..."
(
  [ -d /usr/local/go ] && exit
  cd $(mktemp --directory)
  wget -q https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xf go${GO_VERSION}.linux-amd64.tar.gz
  echo 'PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.profile
)
export PATH=$PATH:/usr/local/go/bin

# Install Packer.
PACKER_VERSION="1.6.4"
echo "  👷‍♀️Installing Packer ${PACKER_VERSION}..."
(
  [ -f /usr/local/bin/packer ] && exit
  cd $(mktemp --directory)
  wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
  unzip -qq -u packer_${PACKER_VERSION}_linux_amd64.zip
  sudo cp packer /usr/local/bin
)

# Install Packer builder for ARM images.
echo "  💪 Installing Packer builder for ARM images..."
PACKER_BUILDER_GIT_COMMIT="586c15a2318be5f18927919bbca74ea16b695dc3"
(
  sudo [ -f /root/.packer.d/plugins/packer-builder-arm-image ] && exit
  cd $(mktemp --directory)
  git clone -q https://github.com/solo-io/packer-builder-arm-image
  cd packer-builder-arm-image
  git checkout -q 586c15a2318be5f18927919bbca74ea16b695dc3
  go mod download
  go build
  sudo mkdir -p /root/.packer.d/plugins
  sudo cp packer-builder-arm-image /root/.packer.d/plugins
)

echo "🚀 Build environment set up!"
