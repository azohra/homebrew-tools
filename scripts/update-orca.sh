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

# One branch per cask, rebuilt from main on every run, so a new release
# rewrites the open proposal instead of opening another pull request beside it.
branch=automation/orca
title="Update Orca to $version"
body="Mirrors the upstream cask at $upstream for v$version and regenerates the API metadata."

git fetch origin main "$branch" 2>/dev/null || git fetch origin main
git switch -C "$branch" origin/main
git add Casks/orca.rb api/cask/orca.json
git -c user.name="github-actions[bot]" \
  -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit -m "$title"

if git rev-parse --verify -q "refs/remotes/origin/$branch" >/dev/null &&
  git diff --quiet "origin/$branch" HEAD; then
  echo "Orca $version is already proposed on $branch"
  exit 0
fi

git push --force-with-lease --set-upstream origin "$branch"

if gh pr list --head "$branch" --state open --json url --jq '.[0].url' | grep -q .; then
  gh pr edit "$branch" --title "$title" --body "$body"
else
  gh pr create --base main --head "$branch" --title "$title" --body "$body"
fi
