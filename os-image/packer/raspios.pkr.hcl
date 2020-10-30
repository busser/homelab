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
}
