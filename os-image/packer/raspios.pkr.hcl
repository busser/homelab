# The hostname the Pi will have.
variable "pi_hostname" {
  type    = string
  default = "raspberrypi"
}

# The hostname the Pi will have.
variable "pi_username" {
  type = string
}

# Bsae64-encoded list of authorized SSH keys.
variable "authorized_keys_b64" {
  type = string
}

# The password of the WiFi network the Pi will connect to.
variable "wifi_password" {
  type      = string
  sensitive = true
}

# The SSID (ie. name) of the WiFi network the Pi will connect to.
variable "wifi_ssid" {
  type = string
}

# Start from a standard Raspberry Pi OS image.
source "arm-image" "raspios" {
  iso_url      = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2020-08-24/2020-08-20-raspios-buster-arm64-lite.zip"
  iso_checksum = "sha256:0639c516aa032df314b176bda97169bdc8564e7bc5afd4356caafbc3f6d090ed"

  output_filename = "${var.pi_hostname}.img"
}

build {
  sources = [
    "source.arm-image.raspios"
  ]

  # Set WiFi credentials.
  provisioner "shell" {
    inline = [
      "echo country=FR >> /etc/wpa_supplicant/wpa_supplicant.conf",
      "wpa_passphrase \"${var.wifi_ssid}\" \"${var.wifi_password}\" | sed -e 's/#.*$//' -e '/^$/d' >> /etc/wpa_supplicant/wpa_supplicant.conf",
    ]
  }

  # Enable WiFi on boot.
  # To do this, create a service that unblocks WiFi after the OS has booted.
  provisioner "file" {
    source      = "/vagrant/files/rfkill-unblock-wifi.service"
    destination = "/etc/systemd/system/rfkill-unblock-wifi.service"
  }
  provisioner "shell" {
    inline = [
      "systemctl enable rfkill-unblock-wifi",
    ]
  }
  # Create a username to log in as.
  # This user will have password-less sudoer capabilities.
  provisioner "shell" {
    inline = [
      "useradd --create-home --groups=sudo ${var.pi_username}",
      "echo \"${var.pi_username} ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/010_${var.pi_username}-nopasswd"
    ]
  }

  # Upload public keys for SSH authentication.
  provisioner "shell" {
    inline = [
      "mkdir -p /home/${var.pi_username}/.ssh",
      "chmod 700 /home/${var.pi_username}/.ssh",
      "echo \"${var.authorized_keys_b64}\" | base64 -d > /home/${var.pi_username}/.ssh/authorized_keys",
      "chmod 600 /home/${var.pi_username}/.ssh/authorized_keys",
      "chown -R ${var.pi_username}:${var.pi_username} /home/${var.pi_username}"
    ]
  }

  # Disable password authentication, for enhanced security.
  provisioner "shell" {
    inline = [
      "sed '/PasswordAuthentication/d' -i /etc/ssh/sshd_config",
      "echo >> /etc/ssh/sshd_config",
      "echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config",
    ]
  }

  # Enable SSH.
  provisioner "shell" {
    inline = [
      "touch /boot/ssh",
    ]
  }
  # Set the Pi's hostname.
  provisioner "shell" {
    inline = [
      "sed -i 's/raspberrypi/${var.pi_hostname}/' /etc/hosts",
      "echo '${var.pi_hostname}' > /etc/hostname"
    ]
  }
}
