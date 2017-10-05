# drone-bitbucket-artifacts
[![drone-bitbucket-artifacts on Docker Hub](https://img.shields.io/docker/automated/albinodrought/drone-bitbucket-artifacts.svg)](https://hub.docker.com/r/albinodrought/drone-bitbucket-artifacts/)
[![Docker Pulls](https://img.shields.io/docker/pulls/albinodrought/drone-bitbucket-artifacts.svg)](https://hub.docker.com/r/albinodrought/drone-bitbucket-artifacts)

This is a Bash [Drone](https://github.com/drone/drone) plugin to deploy build artifacts to Bitbucket.

For more information on how to use the plugin, please take a look at [the docs](https://github.com/AlbinoDrought/drone-bitbucket-artifacts/blob/master/DOCS.md).

## Docker
Build the docker image by running:

```bash
docker build --rm=true -t albinodrought/drone-bitbucket-artifacts .
```

## Usage
To publish artifacts, execute the following from the working directory:

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

To publish and link artifacts, execute the following form the working directory:

```bash
docker run --rm \
  -e PLUGIN_AUTH_STRING="username:app-password" \
  -e PLUGIN_REPO_OWNER="albinodrought" \
  -e PLUGIN_REPO_SLUG="hello-world" \
  -e PLUGIN_FILE="foo.txt" \
  -e PLUGIN_LINK="true" \
  -e DRONE_COMMIT_SHA="6107f58e83a7c7db89e8e63762d668eb095cdd9f" \
  -e PLUGIN_ARTIFACT_KEY="drone-bitbucket-artifacts" \
  -e PLUGIN_ARTIFACT_NAME="Artifact" \
  -e PLUGIN_ARTIFACT_DESCRIPTION="cool build artifact" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  albinodrought/drone-bitbucket-artifacts
```

## Inspiration

[drillster/drone-rsync](https://github.com/Drillster/drone-rsync)
