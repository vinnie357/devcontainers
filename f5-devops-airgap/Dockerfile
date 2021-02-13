# based on microsoft codespaces containers thank you!
# [Choice] Ubuntu version: bionic, focal

FROM vinnie357/f5-devops-base:latest

ENV USERNAME="f5-devops" \
    USER_UID=1000 \
    USER_GID=$USER_UID \
    SHELL="/bin/bash" \
    GOROOT="/usr/local/go" \
    GOPATH="/go" \
    GOVERSION="1.15.6" \
    PRECOMMITVERSION="latest" \
    TERRAFORMVERSION="0.14.0" \
    TERRAFORMDOCSVERSION="0.9.1" \
    ANSIBLEVERSION="2.10.5" \
    VESCTL_VERSION="0.2.15"

COPY scripts/* /tmp/scripts/
# switch back to root for installs
USER root
# add extras
RUN set -ex \
    && bash /tmp/scripts/get-atc-debian.sh \
    && bash /tmp/scripts/terraform-debian.sh "${TERRAFORMVERSION}" \
    && echo "f5 cli" \
    && pip3 install f5-cli

# Clean up
RUN set -ex \
&& apt autoremove -y && apt clean -y

#change user
USER ${USERNAME}
