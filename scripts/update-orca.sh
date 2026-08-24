#!/bin/sh
set -eu

upstream=stablyai/homebrew-orca

scratch=$(mktemp -d "${TMPDIR:-/tmp}/orca-cask.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
curl -fsSL "https://raw.githubusercontent.com/$upstream/HEAD/Casks/orca.rb" \
  -o "$scratch/orca.rb"

flat=$(tr -d ' \n' < "$scratch/orca.rb")
version=$(printf %s "$flat" | grep -o 'version"[0-9.]*"' | head -1 | cut -d'"' -f2)
arm=$(printf %s "$flat" | grep -o 'arm:"[0-9a-f]\{64\}"' | cut -d'"' -f2)
intel=$(printf %s "$flat" | grep -o 'intel:"[0-9a-f]\{64\}"' | cut -d'"' -f2)
if [ -z "$version" ] || [ -z "$arm" ] || [ -z "$intel" ]; then
  echo "could not read version and sha256 pair from upstream cask" >&2
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

branch="automation/orca-$version"
git fetch origin main "$branch" 2>/dev/null || git fetch origin main
git switch -C "$branch" origin/main
git add Casks/orca.rb api/cask/orca.json
git -c user.name="github-actions[bot]" \
  -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit -m "Update Orca to $version"
git push --force-with-lease --set-upstream origin "$branch"

if ! gh pr list --head "$branch" --state open --json url --jq '.[0].url' | grep -q .; then
  gh pr create \
    --base main \
    --head "$branch" \
    --title "Update Orca to $version" \
    --body "Mirrors the upstream cask at $upstream for v$version and regenerates the API metadata."
fi
