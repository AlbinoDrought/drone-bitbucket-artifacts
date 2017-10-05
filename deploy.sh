#!/bin/bash

if [ -z "$PLUGIN_AUTH_STRING" ]; then
    echo "Specify auth string!"
    exit 1
fi

if [ -z "$PLUGIN_REPO_OWNER" ]; then
    echo "Specify repo owner!"
    exit 1
fi

if [ -z "$PLUGIN_REPO_SLUG" ]; then
    echo "Specify repo slug!"
    exit 1
fi

if [ -z "$PLUGIN_FILE" ]; then
    echo "Specify file!"
    exit 1
fi

# Step 1:
# Publish Artifact

curl --fail -X POST --user "$PLUGIN_AUTH_STRING" "https://api.bitbucket.org/2.0/repositories/$PLUGIN_REPO_OWNER/$PLUGIN_REPO_SLUG/downloads" --form files=@"$PLUGIN_FILE"

RESULT=$?

if [ $RESULT -ne 0 ]; then
    exit $RESULT
fi

# Step 2: (optional, only if link: true)
# Link Artifact

if [ -z "$PLUGIN_LINK" ]; then
    # If we're not supposed to link the artifact, exit here
    exit $RESULT
fi

# Human-readable artifact name, shown on Bitbucket UI
ARTIFACT_NAME=$PLUGIN_ARTIFACT_NAME
if [ -z "$PLUGIN_ARTIFACT_NAME" ]; then
    ARTIFACT_NAME="Artifact"
    echo "No artifact name specified, using default '$ARTIFACT_NAME'"
fi

# Key unique to this artifact/step
# If multiple artifacts are deployed with the same key, they will overwrite eachother.
ARTIFACT_KEY=$PLUGIN_ARTIFACT_KEY
if [ -z "$PLUGIN_ARTIFACT_KEY" ]; then
    ARTIFACT_KEY="drone-bitbucket-artifacts"
    echo "No artifact key specified, using default '$ARTIFACT_KEY'"
fi

ARTIFACT_DESCRIPTION=$PLUGIN_ARTIFACT_DESCRIPTION
if [ -z "$PLUGIN_ARTIFACT_DESCRIPTION" ]; then
    ARTIFACT_DESCRIPTION=""
fi

curl -H "Content-Type: application/json" \
    -X POST --user "$PLUGIN_AUTH_STRING" \
    -d "{\"key\": \"$ARTIFACT_KEY\", \"description\": \"$ARTIFACT_DESCRIPTION\", \"state\": \"SUCCESSFUL\", \"name\": \"$ARTIFACT_NAME\", \"url\": \"https://bitbucket.org/$PLUGIN_REPO_OWNER/$PLUGIN_REPO_SLUG/downloads/$PLUGIN_FILE\"}" \
    "https://api.bitbucket.org/2.0/repositories/$PLUGIN_REPO_OWNER/$PLUGIN_REPO_SLUG/commit/$DRONE_COMMIT_SHA/statuses/build"

exit $?
