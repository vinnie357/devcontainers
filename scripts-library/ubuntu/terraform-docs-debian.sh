#!/bin/bash
echo "---installing terraform docs---"

terraformDocsVersion=${1:-"0.15.0"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

curl -sLo terraform-docs.tar.gz https://github.com/segmentio/terraform-docs/releases/download/v${terraformDocsVersion}/terraform-docs-v${terraformDocsVersion}-linux-amd64.tar.gz
tar -xf terraform-docs.tar.gz terraform-docs
mv terraform-docs /usr/local/bin/terraform-docs
chmod 0755 /usr/local/bin/terraform-docs

echo "---terraform docs done---"
