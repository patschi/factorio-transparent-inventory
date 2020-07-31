#!/bin/bash
#
# Requirements:
# $ apt install git jq coreutils
#
if ! which jq &>/dev/null; then echo "Command jq not found. Install it."; exit 1; fi
if ! which git &>/dev/null; then echo "Command git not found. Install it."; exit 1; fi
if ! which md5sum &>/dev/null; then echo "Command md5sum not found. Install it"; exit 1; fi
if ! which sha1sum &>/dev/null; then echo "Command sha1sum not found. Install it"; exit 1; fi
if ! which sha256sum &>/dev/null; then echo "Command sha256sum not found. Install it"; exit 1; fi
if ! which sha384sum &>/dev/null; then echo "Command sha384sum not found. Install it"; exit 1; fi

MODE=$1

# check dirty state.
if ! git diff --no-ext-diff --quiet --exit-code; then
	echo "Local git repo is in a dirty state. There are uncommitted changes. Please check!"
	echo "Sleeping for 5 seconds before proceeding..."
	sleep 5
fi

echo "* Let's start..."

# parse info details
echo "* Parsing info file..."
INFO_JSON=$(cat info.json)
INFO_NAME=$(echo $INFO_JSON | jq --raw-output '.name')
INFO_TITLE=$(echo $INFO_JSON | jq --raw-output '.title')
INFO_VERSION=$(echo $INFO_JSON | jq --raw-output '.version')

FOLDER_NAME=${INFO_NAME}_${INFO_VERSION}
ZIP_ARCHIVE="${INFO_NAME}_${INFO_VERSION}.zip"

# Let's create a git tag for this release
echo "- Tagging release 'v${INFO_VERSION}'..."
git tag --force --annotate "v${INFO_VERSION}" --message "${INFO_TITLE} v${INFO_VERSION} released."

# making a zip
echo "- Creating ZIP archive..."
git archive --format=zip --prefix "${FOLDER_NAME}/" -o "${ZIP_ARCHIVE}" "v${INFO_VERSION}"

# Generating hashes
echo "- Creating archive hashes..."
HASHES=$(cat << EOF
- MD5: $(md5sum "${ZIP_ARCHIVE}" | awk -F' ' '{ print $1 }')
- SHA-1: $(sha1sum "${ZIP_ARCHIVE}" | awk -F' ' '{ print $1 }')
- SHA-256: $(sha256sum "${ZIP_ARCHIVE}" | awk -F' ' '{ print $1 }')
- SHA3-384: $(sha384sum "${ZIP_ARCHIVE}" | awk -F' ' '{ print $1 }')
EOF
)

# Parsing Changelog file
echo "- Parsing CHANGELOG file..."
CHANGELOG=$(cat CHANGELOG.md | sed '0,/^- /d;/^- /Q;s/^[[:space:]]*//g;/^$/d')

# Getting final output together
OUTPUT=$(cat << EOF
**Changes**
$CHANGELOG

**Hashes**
Filename: ${ZIP_ARCHIVE}
$HASHES
EOF
)

echo "- Finalizing..."
# check if release mode.
if [ "$MODE" == "release" ]; then
	echo "- Updating git..."
	echo "Pushing git..."
	git push --all
	echo "Pushing tags..."
	git push --tags --force
	echo "Release 'v${INFO_VERSION}' done!"
else
	echo "Release archive for 'v${INFO_VERSION}' created!"
fi

echo "Generated release text:"
echo "-----"
echo -e "$OUTPUT"
echo "-----"
