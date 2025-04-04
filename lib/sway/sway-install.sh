#!/bin/bash

username="$(logname)"

# check for sudo
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run with sudo"
  exit 1
fi

# install the package list
echo "Installing needed packages..."
yay -S --noconfirm --noprogressbar --needed --disable-download-timeout $(< packages-repository.txt)

# enable greetd service
echo "Enabling Greetd service..."
systemctl -f enable greetd.service

echo "Installation complete"
