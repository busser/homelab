# The SSID (ie. name) of the WiFi network the Pi will connect to.
variable "wifi_ssid" {
  type = string
}

# The password of the WiFi network the Pi will connect to.
variable "wifi_password" {
  type      = string
  sensitive = true
}

# The hostname the Pi will have.
variable "pi_hostname" {
  type    = string
  default = "raspberrypi"
}

# The hostname the Pi will have.
variable "pi_username" {
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
}
