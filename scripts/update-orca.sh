#!/bin/sh
set -eu

upstream=stablyai/homebrew-orca

if [ -n "$(git status --porcelain=v1)" ]; then
  echo "update-orca: refusing — working tree is dirty" >&2
  exit 1
fi

scratch=$(mktemp -d "${TMPDIR:-/tmp}/orca-cask.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
curl -fsSL "https://raw.githubusercontent.com/$upstream/HEAD/Casks/orca.rb" \
  -o "$scratch/orca.rb"

version=$(sed -n 's/^  version "\([0-9.]*\)"$/\1/p' "$scratch/orca.rb")
arm=$(sed -n 's/^  sha256 arm: *"\([0-9a-f]\{64\}\)",$/\1/p' "$scratch/orca.rb")
intel=$(sed -n 's/^         intel: "\([0-9a-f]\{64\}\)"$/\1/p' "$scratch/orca.rb")
if [ -z "$version" ] || [ -z "$arm" ] || [ -z "$intel" ]; then
  echo "update-orca: refusing — could not read the upstream release fields" >&2
  exit 1
fi

normalize_cask() {
  sed \
    -e '/^[[:space:]]*#/d' \
    -e '/^[[:space:]]*$/d' \
    -e 's/^  version ".*"$/  version "VERSION"/' \
    -e 's/^  sha256 arm:.*$/  sha256 arm: "ARM",/' \
    -e 's/^         intel: .*$/         intel: "INTEL"/' \
    "$1"
}
normalize_cask Casks/orca.rb > "$scratch/local.normalized"
normalize_cask "$scratch/orca.rb" > "$scratch/upstream.normalized"
if ! cmp -s "$scratch/local.normalized" "$scratch/upstream.normalized"; then
  diff -u "$scratch/local.normalized" "$scratch/upstream.normalized" >&2 || true
  echo "update-orca: refusing — upstream cask behavior changed; review Casks/orca.rb" >&2
  exit 1
fi

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' Casks/orca.rb)
if [ "$version" = "$current" ]; then
  echo "Orca cask is already current at $version"
  exit 0
fi

sed \
  -e "s|^  version \".*\"\$|  version \"$version\"|" \
  -e "s|^  sha256 arm:.*\$|  sha256 arm:   \"$arm\",|" \
  -e "s|^         intel: .*\$|         intel: \"$intel\"|" \
  Casks/orca.rb > "$scratch/orca-new.rb"
mv "$scratch/orca-new.rb" Casks/orca.rb
ruby -c Casks/orca.rb
grep -Fq "\"$version\"" Casks/orca.rb
grep -Fq "\"$arm\"" Casks/orca.rb
grep -Fq "\"$intel\"" Casks/orca.rb

./scripts/orca-api-json.sh

echo "Updated orca package files"
