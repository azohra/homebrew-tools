#!/bin/sh
# Regenerate api/cask/orca.json from Casks/orca.rb so consumers that read
# tap API metadata (mise's brew-cask backend) see the same cask brew does.
# Produces arm64 macOS metadata. Linux uses Homebrew's macOS audit simulation;
# environment-specific artifact paths are normalized below.
set -eu

cd "$(dirname "$0")/.."

command -v brew >/dev/null || {
  echo "orca-api-json: refusing — Homebrew is not installed" >&2
  exit 1
}
command -v jq >/dev/null || {
  echo "orca-api-json: refusing — jq is not installed" >&2
  exit 1
}
if [ "$(uname -s)" = Linux ]; then
  export HOMEBREW_SIMULATE_MACOS_ON_LINUX=1
fi

# Keep inherited repository state out of the isolated tap below or its
# temporary commit can capture the caller's staged files.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_COMMON_DIR GIT_OBJECT_DIRECTORY GIT_PREFIX

taproot="$(brew --repository)/Library/Taps/azohra-metadata"
tapdir="$taproot/homebrew-tools-metadata"
if [ -e "$taproot" ]; then
  echo "orca-api-json: refusing — temporary tap already exists: $taproot" >&2
  exit 1
fi
trap 'rm -rf "$taproot"' EXIT HUP INT TERM
mkdir -p "$tapdir/Casks"
cp Casks/orca.rb "$tapdir/Casks/orca.rb"
git -C "$tapdir" init -q
git -C "$tapdir" add Casks/orca.rb
git -C "$tapdir" -c user.email=check@local -c user.name=check \
  commit -q -m staged

metadata="$taproot/orca.json"
# Normalize fields that vary by environment so the file is reproducible and
# CI can diff a regeneration against the committed copy: tap_git_head changes
# with every commit (consumers only need it to fetch cask Ruby for lifecycle
# hooks, which this cask has none of), the installed/bundle fields reflect
# whether the generating machine has Orca installed, the binary target embeds
# the active Homebrew prefix, and url_specs serialization differs across brew
# versions.
brew info --json=v2 azohra-metadata/tools-metadata/orca \
  | jq '.casks[0]
        | del(.tap_git_head, .url_specs)
        | .tap = "azohra/tools"
        | .full_token = "azohra/tools/orca"
        | .installed = null
        | .installed_time = null
        | .bundle_version = null
        | .bundle_short_version = null
        | (.artifacts[] | select(has("app")) | .target) = "/Applications/Orca.app"
        | (.artifacts[] | select(has("binary")) | .binary[0]) = "/Applications/Orca.app/Contents/Resources/bin/orca"
        | (.artifacts[] | select(has("binary")) | .target) = "/opt/homebrew/bin/orca"' > "$metadata"

jq -e '.token == "orca" and .tap == "azohra/tools"' "$metadata" \
  > /dev/null
mkdir -p api/cask
mv "$metadata" api/cask/orca.json
