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

curl --fail -X POST --user "$PLUGIN_AUTH_STRING" "https://api.bitbucket.org/2.0/repositories/$PLUGIN_REPO_OWNER/$PLUGIN_REPO_SLUG/downloads" --form files=@"$PLUGIN_FILE"

exit $?
