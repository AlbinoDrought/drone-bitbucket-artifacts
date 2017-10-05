# drone-bitbucket-artifacts
[![drone-bitbucket-artifacts on Docker Hub](https://img.shields.io/docker/automated/albinodrought/drone-bitbucket-artifacts.svg)](https://hub.docker.com/r/albinodrought/drone-bitbucket-artifacts/)

This is a Bash [Drone](https://github.com/drone/drone) plugin to deploy build artifacts to Bitbucket.

## Docker
Build the docker image by running:

```bash
docker build --rm=true -t albinodrought/drone-bitbucket-artifacts .
```

## Usage
Execute from the working directory:

```bash
docker run --rm \
  -e PLUGIN_AUTH_STRING="username:app-password" \
  -e PLUGIN_REPO_OWNER="albinodrought" \
  -e PLUGIN_REPO_SLUG="hello-world" \
  -e PLUGIN_FILE="foo.txt" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  albinodrought/drone-bitbucket-artifacts
```

## Inspiration

[drillster/drone-rsync](https://github.com/Drillster/drone-rsync)
