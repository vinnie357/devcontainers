# based on microsoft codespaces containers thank you!
# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"

FROM ubuntu:${VARIANT}

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
    VESCTL_VERSION="0.2.15"\
    SPHINX_VERSION="3.3.1"

COPY scripts/* /tmp/scripts/

# base
RUN set -ex \
&& apt update && export DEBIAN_FRONTEND=noninteractive \
&& apt -y install --no-install-recommends \
sudo \
git \
zsh
# user
RUN set -ex \
 && bash /tmp/scripts/create-user.sh ${USERNAME} ${USER_UID}  \
 && bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}"
# common packages
RUN bash /tmp/scripts/common-debian.sh "true" "${USERNAME}" "${USER_UID}" "${USER_GID}" "false" "true"
#python/pip
RUN set -ex \
    && apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends \
    dnsutils \
    python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && ln -s /usr/bin/pip3 /usr/bin/pip
# docker
RUN set -ex \
  && bash /tmp/scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "true"

# Clean up
RUN set -ex \
&& apt autoremove -y && apt clean -y && rm -rf /tmp/scripts

#change user
USER ${USERNAME}
