# f5-devops-airgap container based on f5-devops-base

size about 672MB in example, will vary by need.

## tools:

### from base
- git
- jq
- curl
- wget
- zsh
- oh-my-bash/zsh
- python3

### modify and add tools for your customer

default example includes:

- f5cli
- atc rpms


### build and tag with your customer need
```bash
cd f5-devops-airgap
```
customize dockerfile to add needed scripts from scripts-library
```bash
RUN set -ex \
    && bash /tmp/scripts/get-atc-debian.sh \
    && bash /tmp/scripts/your-script-here.sh
```
build local to test:
```bash
IMAGE_NAME="f5-devops-airgap"
docker build -t ${IMAGE_NAME} .
# test your build locally
docker run --rm -it ${CONTAINER_IMAGE} bash
```
if successful tag and push to registry:
```bash
REGISTRY="myregistry"
IMAGE_NAME="f5-devops-airgap"
IMAGE_TAG="mytag"
# https://docs.docker.com/engine/reference/commandline/tag/
# alernatively you can build a new image and tag to preseve local
docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
# !login to your registry!
# note: docker desktop may also log you in
docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
```
