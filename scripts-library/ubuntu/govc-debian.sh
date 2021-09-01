# https://github.com/vmware/govmomi/blob/master/govc/README.md
#!/bin/bash
echo "---installing govc ---"
USERNAME=${1:-"f5-devops"}
govcVersion=${2:-"latest"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi
# extract govc binary to /usr/local/bin
# note: the "tar" command must run with root permissions
curl -sL -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - govc

echo "---govc done---"
