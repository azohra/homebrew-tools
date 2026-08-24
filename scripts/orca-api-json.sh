#!/bin/sh
# Regenerate api/cask/orca.json from Casks/orca.rb so consumers that read
# tap API metadata (mise's brew-cask backend) see the same cask brew does.
# Runs on arm64 macOS: brew evaluates the cask for the local platform, and
# arm64 is the only macOS platform mise's brew backend supports.
set -eu

cd "$(dirname "$0")/.."

tapdir=$(brew --repository azohra/tools)
if [ ! -d "$tapdir" ]; then
  brew tap azohra/tools "$PWD"
  tapdir=$(brew --repository azohra/tools)
fi

# Evaluate the working-tree cask, not whatever revision the tap clone holds,
# then put the clone back the way it was.
cp Casks/orca.rb "$tapdir/Casks/orca.rb"
mkdir -p api/cask
# Normalize fields that vary by environment so the file is reproducible and
# CI can diff a regeneration against the committed copy: tap_git_head changes
# with every commit (consumers only need it to fetch cask Ruby for lifecycle
# hooks, which this cask has none of), the installed/bundle fields reflect
# whether the generating machine has Orca installed, and url_specs
# serialization differs across brew versions.
brew info --json=v2 azohra/tools/orca \
  | jq '.casks[0]
        | del(.tap_git_head, .url_specs)
        | .installed = null
        | .installed_time = null
        | .bundle_version = null
        | .bundle_short_version = null' > api/cask/orca.json
git -C "$tapdir" checkout -- Casks/orca.rb 2>/dev/null \
  || rm -f "$tapdir/Casks/orca.rb"

jq -e '.token == "orca" and .tap == "azohra/tools"' api/cask/orca.json \
  > /dev/null
