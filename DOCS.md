Use the Bitbucket Artifacts plugin to deploy build artifacts to Bitbucket Downloads.

## Config
The following parameters are used to configure the plugin:
- **auth_string** - username/password (app-password) pair used to authenticate with Bitbucket
- **repo_owner** - owner of the Bitbucket repository (https://bitbucket.org/**albinodrought**/hello-world)
- **repo_slug** - slug of the Bitbucket repository (https://bitbucket.org/albinodrought/**hello-world**)
- **file** - path of build artifact to deploy
- **link** - if set, link the deployed artifact to the current commit
- **artifact_key** - unique (per commit) key of this artifact for linking, defaults to `drone-bitbucket-artifacts` [(`key` field)](https://confluence.atlassian.com/bitbucket/integrate-your-build-system-with-bitbucket-cloud-790790968.html)
- **artifact_name** - Human-readable name of this artifact for linking, defaults to `Artifact` [(`name` field)](https://confluence.atlassian.com/bitbucket/integrate-your-build-system-with-bitbucket-cloud-790790968.html)
- **artifact_description** - Human-readable description of this artifact for linking, defaults to `` [(`description` field)](https://confluence.atlassian.com/bitbucket/integrate-your-build-system-with-bitbucket-cloud-790790968.html)

It is highly recommended to put your **auth_string** into a secret so it is not exposed to users. This can be done using the drone-cli.

```sh
drone secret add \
    --repository "albinodrought/hello-world" \
    --name AUTH_STRING \
    --value "user:app-password"
```

Add the secret to your `.drone.yml`:
```yaml
pipeline:
  build-artifact:
    image: albinodrought/drone-bitbucket-artifacts
    secrets:
     - source: auth_string
     - target: plugin_auth_string
    repo_owner: albinodrought
    repo_slug: hello-world
    file: build.tar.gz
```

See the [Secret Guide](http://readme.drone.io/usage/secret-guide/) for additional information on secrets.

## Examples

```yaml
pipeline:
  build:
    image: albinodrought/node-alpine-gcc-make-ssh
    commands:
      - npm run build
      - tar -cvzf "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz" dist

  artifact:
    image: albinodrought/drone-bitbucket-artifacts
    file: "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz"
    repo_owner: albinodrought
    repo_slug: hello-world
    secrets:
      - source: AUTH_STRING
        target: plugin_auth_string
```

The example above uses string interpolation to change the filename based upon branch and commit hash using drone-provided environment variables. A reference can be found [here](http://readme.drone.io/0.5/usage/environment-reference/). 

```yaml
pipeline:
  build:
    image: albinodrought/node-alpine-gcc-make-ssh
    commands:
      - npm run build
      - tar -cvzf "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz" dist

  artifact:
    image: albinodrought/drone-bitbucket-artifacts
    file: "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz"
    repo_owner: albinodrought
    repo_slug: hello-world
    link: true
    secrets:
      - source: AUTH_STRING
        target: plugin_auth_string
```

The example above sets `link` to true, which will link the deployed artifact to the triggering commit. This uses defaults for key, name, and description.

```yaml
pipeline:
  build:
    image: albinodrought/node-alpine-gcc-make-ssh
    commands:
      - npm run test
      - cp test/unit/coverage/lcov.info lcov-${DRONE_COMMIT_SHA}.info
      - tar -cvzf "lcov-report-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz" test/unit/coverage/lcov-report
      - npm run build
      - tar -cvzf "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz" dist

  artifact-lcov:
    image: albinodrought/drone-bitbucket-artifacts
    file: "lcov-${DRONE_COMMIT_SHA}.info"
    repo_owner: albinodrought
    repo_slug: hello-world
    link: true
    artifact_key: lcov
    artifact_name: "lcov.info"
    secrets:
      - source: AUTH_STRING
        target: plugin_auth_string

  artifact-lcov-report
    image: albinodrought/drone-bitbucket-artifacts
    file: "lcov-report-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz"
    repo_owner: albinodrought
    repo_slug: hello-world
    link: true
    artifact_key: lcov-report
    artifact_name: "Coverage Report"
    artifact_description: "lcov-report for this build"
    secrets:
      - source: AUTH_STRING
        target: plugin_auth_string


  artifact-build:
    image: albinodrought/drone-bitbucket-artifacts
    file: "build-${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA}.tar.gz"
    repo_owner: albinodrought
    repo_slug: hello-world
    link: true
    artifact_key: built-files
    artifact_name: "Built Files"
    artifact_description: "Bundled Webpack files, ready for production"
    secrets:
      - source: AUTH_STRING
        target: plugin_auth_string
```

The example above deploys multiple artifacts, linking each one to the same commit using unique keys.
