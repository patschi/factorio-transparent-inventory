#!/bin/bash

# parse info details
echo "Parsing info file..."
INFO_JSON=$(cat info.json)
INFO_NAME=$(echo $INFO_JSON | jq --raw-output '.name')
INFO_TITLE=$(echo $INFO_JSON | jq --raw-output '.title')
INFO_VERSION=$(echo $INFO_JSON | jq --raw-output '.version')

FOLDER_NAME=${INFO_NAME}_${INFO_VERSION}
BUILD_DIR=/tmp/FACTORIO_MOD_${FOLDER_NAME}/

# Let's create a git tag for this release
echo "Tagging release..."
git tag --force "v${INFO_VERSION}"

# making a zip
echo "Creating ZIP archive..."
git archive --format=zip --prefix "${FOLDER_NAME}/" -o "${FOLDER_NAME}.zip" "v${INFO_VERSION}"

echo "Done."
