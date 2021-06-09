#!/bin/bash
echo "---installing kubctx/kubens---"

version=${1:-"0.9.1"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

curl -LOs https://github.com/ahmetb/kubectx/releases/download/v${version}/kubectx
chmod +x ./kubectx
mv ./kubectx /usr/local/bin/kubectx
kubectx -h
curl -LOs https://github.com/ahmetb/kubectx/releases/download/v${version}/kubens
chmod +x ./kubens
mv ./kubens /usr/local/bin/kubens
kubens -h

echo "---kubctx/kubens done---"
