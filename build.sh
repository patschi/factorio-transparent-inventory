#!/bin/bash
MODE=$1

# check dirty state.
if ! git diff --no-ext-diff --quiet --exit-code; then
	echo "We're in a dirty state. There are uncommitted changes. Please check!"
	echo "Sleeping for 5 seconds before proceeding..."
	sleep 5
fi

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

# check if release mode.
if [ "$MODE" == "release" ]; then
	echo "Pushing git..."
	git push --all
	git push --tags
fi

echo "Done."
