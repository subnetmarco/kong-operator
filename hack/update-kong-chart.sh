#!/bin/bash

set -e

TAG=$1
[ -z "$TAG" ] && { echo "usage: $0 <git_tag>"; exit 1; }

# Go to the repository root
cd $(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)

# Ensure that there are no staged changes
git diff-index --quiet --cached HEAD -- || { echo "error: please run this script without staged changes in git"; exit 1; }

# Clone
TEMPDIR="$(mktemp -d)"
git clone https://github.com/Kong/charts.git --branch "$TAG" $TEMPDIR

# Replace the existing chart with the copy
rm -rv ./helm-charts/kong
cp -r $TEMPDIR/charts/kong ./helm-charts/kong
git add ./helm-charts/kong
git commit \
	-m "charts(kong): update to $TAG" \
	-m "generator command: '$*'" \
	-m "generator command version: $(git rev-parse HEAD)"

# Clean up temp files
rm -rf "$TEMPDIR"
