# auto-epp
[![auto-epp](https://img.shields.io/aur/version/auto-epp?color=1793d1&label=auto-epp&logo=arch-linux&style=for-the-badge)](https://aur.archlinux.org/packages/auto-epp/)

**auto-epp** is a python script that manages the energy performance preferences (EPP) of your AMD CPU using the AMD-Pstate driver. It adjusts the EPP settings based on whether your system is running on AC power or battery power, helping optimize power consumption and performance.

## Index

- [Requirements](#requirements)
- [Enable amd-pstate-epp](#to-enable-amd-pstate-epp)
- [Quick Install](#quick-install)
  - [For Archlinux](#for-arch-linux)
- [Manual Install](#manual-install)
- [Usage](#usage)

## Requirements

- AMD CPU with the AMD-Pstate-EPP driver enabled.
- Python 3.x

## To enable amd-pstate-epp

This can be done by editing the `GRUB_CMDLINE_LINUX_DEFAULT` params in `/etc/default/grub`. Follow these steps:

1. Open the grub file using the following command:
```bash
sudo nano /etc/default/grub
```
2. Within the file, modify the `GRUB_CMDLINE_LINUX_DEFAULT` line to include the setting for AMD P-State EPP:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_pstate=active"
```

## Quick Install

To quickly install auto-epp, just copy and paste this to your terminal (if you have curl installed):
```bash
curl https://raw.githubusercontent.com/jothi-prasath/auto-epp/master/quick-install.sh | sudo bash
```
### For Arch Linux

On Arch Linux, and Arch-based distributions, auto-epp can be found in the AUR. Install with an AUR helper like yay:
```bash
yay auto-epp
```

### For NixOS

On NixOS (unstable for now) an option can be enabled to install and set up auto-epp.

To enable with the default configuration:

```nix
services.auto-epp.enable = true;
```

Detailed options available on [nixos.org](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=auto-epp)

## Manual Install

```bash
git clone https://github.com/jothi-prasath/auto-epp
cd auto-epp
chmod +x ./install.sh
sudo ./install.sh
```

## Usage

Monitor the service status
```bash
systemctl status auto-epp
```

To restart the service
```bash
sudo systemctl restart auto-epp
```

Edit the config file
```bash
sudo nano /etc/auto-epp.conf
```
