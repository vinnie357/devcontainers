ARG VARIANT="focal"

FROM ubuntu:${VARIANT}

ENV USERNAME="vscode" \
    USER_UID=1000 \
    USER_GID=$USER_UID \
    PYTHONVERSION="latest" \
    GOVERSION="1.15.6"

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
# tools
RUN set -ex \
&& bash /tmp/scripts/python-debian.sh "${PYTHONVERSION}"\
&& bash /tmp/scripts/go-debian.sh "${GOVERSION}" "" "" "" "true" "false" \
&& bash /tmp/scripts/pre-commit-debian.sh


USER ${USERNAME}
