# Installation

Didn't document, but install headless dietpi: https://dietpi.com/docs/install/#2-flash-the-dietpi-image

Before booting for the first time:
- edit the file "dietpi.txt" and put the AUTO_SETUP_NET_WIFI_ENABLED field to 1
- edit the file "dietpi-wifi.txt" and:
	- set aWIFI_SSID[0] to wifi name
	- set aWIFI_KEY[0] to wifi password

# Setup
first boot dietpi
default login: root
default password: dietpi

I recommend switching to OpenSSH, so that it's easier to set up SFTP to transfer files (notably, the CDM). To do that:
- Run the command `dietpi-software`
- In `SSH Server`, select OpenSSH
- Install

to consume less power, I changed the max CPU frquency by using the command "dietpi-config" -> "3. Performance Options" -> CPU Frequency Limits -> 800 MHz

# Keep in mind

If the Wifi password ever changes:
- In the SD card, edit the following files:
	- /etc/network/interfaces: adjust router IP address
	- /etc/wpa_supplicant/wpa_supplicant.conf: add the new credentials

The repository files are located in $HOME/m3u-tv

# Utilities

Reboot the dietpi using the command: sudo reboot

Launch the web server manually:
```sh
$ cd $HOME/m3u-tv
$ .venv/bin/python server.py
```