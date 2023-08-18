#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Removing old files if exist
if [ -d "auto-epp" ]; then
    echo "Removing old files"
    rm -rf auto-epp &>/dev/null
fi

# Install dependencies based on the package manager available
echo "Installing missing dependencies"
if command -v apt &>/dev/null; then
    apt install -y git python3
elif command -v pacman &>/dev/null; then
    pacman -Syu --noconfirm --needed git python
elif command -v dnf &>/dev/null; then
    dnf install -y git python3
elif command -v zypper &>/dev/null; then
    zypper install -y git python3
else
    echo "Unsupported package manager. Please install the required dependencies manually."
    exit 1
fi

# Clone the repository
repo_url="https://github.com/jothi-prasath/auto-epp"
echo "Cloning the repository..."
if git clone "$repo_url" --depth=1 &>/dev/null; then
    echo "Repository cloned successfully."
else
    echo "Failed to clone the repository. Please check your network connection and try again."
    exit 1
fi

# Changing directory
cd auto-epp

# Installing
if sudo ./install.sh; then
    echo "Installation completed successfully!"
else
    echo "Installation failed."
    exit 1
fi

#Cleaning up the directory
echo "Cleaning directory..."
cd ..
rm auto-epp -rf &>/dev/null