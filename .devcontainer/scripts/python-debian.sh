#!/bin/bash
echo "---installing python-pip---"

python=${1:-"latest"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi
# install
apt update && export DEBIAN_FRONTEND=noninteractive \
&& apt -y install --no-install-recommends \
    python3-pip \
# symlinks
ln -s /usr/bin/python3 /usr/bin/python

python3 -m pip install --no-cache-dir --upgrade pip

ln -s /usr/bin/pip3 /usr/bin/pip

echo "---python-pip done---"
