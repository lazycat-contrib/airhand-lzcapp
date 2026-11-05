#!/bin/sh
# Fetch the upstream source that lzc-build.yml embeds.
#
# Airhand publishes no container images (Docker Hub and ghcr both have nothing
# for it), and both of its compose files build from source. So we clone the
# pinned tag here and let the embed step build server/ and web/ from it.
#
# The dockerfiles live inside this checkout, which is what embed requires:
# dockerfile and context must stay within the project root.
set -e

VERSION="${AIRHAND_VERSION:-v0.1.0}"
DEST="upstream"

rm -rf "$DEST"
mkdir -p "$DEST"

echo "fetching airhand $VERSION"
# Try the tag first, fall back to the default branch for unreleased versions.
if ! git clone --depth 1 --branch "$VERSION" https://github.com/sqlpxc/airhand.git "$DEST" 2>/dev/null; then
  echo "tag $VERSION not found, cloning default branch"
  git clone --depth 1 https://github.com/sqlpxc/airhand.git "$DEST"
fi

# The embed context must not pull in the desktop client's build artifacts.
rm -rf "$DEST/.git"

echo "upstream ready:"
ls "$DEST"
