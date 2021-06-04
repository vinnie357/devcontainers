#!/bin/bash
echo "---installing waypoint-cli ---"

waypointVersion=${1:-"0.4.0"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi
apt-get install software-properties-common -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install waypoint=${waypointVersion} -y
waypoint -autocomplete-install
echo "---waypoint-cli done---"
