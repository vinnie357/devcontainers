#!/bin/bash
echo "=====install coder====="
USERNAME=${1:-"f5-devops"}
CODER_VERSION=${2:-"3.9.0"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi
# get software
curl -sSOL https://github.com/cdr/code-server/releases/download/v${CODER_VERSION}/code-server_${CODER_VERSION}_amd64.deb
dpkg -i code-server_${CODER_VERSION}_amd64.deb
# coder config
mkdir -p /home/${USERNAME}/.config/code-server
cat > /home/${USERNAME}/.config/code-server/config.yaml <<EOF
bind-addr: 127.0.0.1:8080
auth: password
password: 1234
cert: false
EOF
chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.config/code-server
# service where systemd available
cat > /lib/systemd/system/code-server.service <<EOF
[Unit]
Description=code-server

[Service]
Type=simple
User=${USERNAME}
#Environment=PASSWORD=your_password
#ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
# config file
ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --config /home/${USERNAME}/.config/code-server/config.yaml --user-data-dir /var/lib/code-server --auth password
# no password
#ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --auth none
Restart=always

[Install]
WantedBy=multi-user.target
EOF
## systemctl enable --now code-server
# install extensions for coder as user
extensionUrls="https://api.github.com/repos/f5devcentral/vscode-f5/releases/latest https://api.github.com/repos/hashicorp/vscode-terraform/releases/tags/v2.4.0"
for downloadUrl in $extensionUrls
do
    wget $(curl -s $downloadUrl | jq -r '.assets[] | select(.name | contains (".vsix")) | .browser_download_url')
done
extensions=$(ls *vsix)
for extension in $extensions
do
    sudo -u ${USERNAME} code-server --install-extension $extension
done
# exit user install
rm *.vsix
#systemctl restart code-server
#service code-server  start
# Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
echo "====self signed cert===="
mkdir -p /cert
openssl genrsa -aes256 -passout pass:1234 -out server.pass.key 2048
openssl rsa -passin pass:1234 -in server.pass.key -out /cert/server.key
rm server.pass.key
openssl req -new -key /cert/server.key -out /cert/server.csr -subj "/C=US/ST=testville/L=testerton/O=Test testing/OU=Test Department/CN=test.example.com"
openssl x509 -req -sha256 -days 365 -in /cert/server.csr -signkey /cert/server.key -out /cert/server.crt
echo "====self signed cert done===="
echo "===nginx==="
apt install nginx -y
cat > /etc/nginx/conf.d/coder.conf <<EOF
# server {
#     listen 80 default_server;
#     server_name _;
#     return 301 https://\$host\$request_uri;
# }
map \$http_upgrade \$connection_upgrade {
        default upgrade;
        '' close;
    }
server {
    listen       443 ssl;
    server_name  localhost;
    ssl_certificate     /cert/server.crt; # The certificate file
    ssl_certificate_key /cert/server.key; # The private key file
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;
    proxy_set_header Host \$host;
    location / {
        proxy_pass http://127.0.0.1:8080;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
echo "====coder done===="
