#!/bin/bash
echo "---installing vesctl---"
VERSION=${1:-"0.2.15"}
set -e

wget https://vesio.azureedge.net/releases/vesctl/"$VERSION"/vesctl.linux-amd64.gz
gzip -d vesctl.linux-amd64.gz
sudo mv vesctl.linux-amd64 /usr/local/bin/vesctl
sudo chmod +x /usr/local/bin/vesctl

echo "---vesctl done---"
