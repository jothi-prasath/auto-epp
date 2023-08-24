#!/bin/bash

sudo chmod +x ./auto-epp
sudo cp auto-epp /usr/bin/ -v
sudo cp auto-epp.service /etc/systemd/system/ -v
sudo systemctl enable auto-epp
sudo systemctl start auto-epp