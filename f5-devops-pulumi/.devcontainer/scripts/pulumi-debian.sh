#!/bin/bash
echo "---installing pulumi---"
USERNAME=${1:-"f5-devops"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

    # apt-get install -y g++
    # pkg_manager="apt-get"
    # python3_pkg="python3"
    # python3_venv_pkg="python3-venv"
    # python3_dev_pkg="python3-dev"
    # gpp_pkg="g++"
    # rustc_pkg="rustc"
    # libssl_dev="libssl-dev"
    curl -fsSL https://get.pulumi.com | sh
    cp /root/.pulumi/bin/pulumi /usr/local/bin/
    chmod 0755 /usr/local/bin/pulumi
    # export PATH=$PATH:$HOME/.pulumi/bin
echo "---pulumi done---"
