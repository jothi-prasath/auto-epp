#!/bin/bash

sudo cp auto-epp /usr/bin/ -v
chmod +x /usr/bin/auto-epp
sudo cp auto-epp.service /etc/systemd/system/ -v
sudo systemctl enable auto-epp
sudo systemctl start auto-epp
