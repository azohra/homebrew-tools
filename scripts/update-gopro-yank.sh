#!/bin/sh
set -eu

repository=azohra/gopro-yank
version=${1:-}
if [ -n "$version" ]; then
  tag="v${version#v}"
else
  tag=$(gh api "repos/$repository/releases/latest" --jq .tag_name)
fi

scratch=$(mktemp -d "${TMPDIR:-/tmp}/gopro-yank-formula.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
gh release download "$tag" --repo "$repository" --pattern gopro-yank.rb --dir "$scratch"

formula="$scratch/gopro-yank.rb"
if ! grep -Fq "/releases/download/$tag/" "$formula"; then
  echo "downloaded formula does not reference $tag" >&2
  exit 1
fi
if cmp -s "$formula" gopro-yank.rb; then
  echo "gopro-yank.rb is already current"
  exit 0
fi

branch="automation/gopro-yank-${tag#v}"
git fetch origin master "$branch" 2>/dev/null || git fetch origin master
git switch -C "$branch" origin/master
cp "$formula" gopro-yank.rb
git add gopro-yank.rb
git -c user.name="github-actions[bot]" \
  -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit -m "Update GoPro Yank to ${tag#v}"
git push --force-with-lease --set-upstream origin "$branch"

if ! gh pr list --head "$branch" --state open --json url --jq '.[0].url' | grep -q .; then
  gh pr create \
    --base master \
    --head "$branch" \
    --title "Update GoPro Yank to ${tag#v}" \
    --body "Updates the GoPro Yank formula from the verified release asset for $tag."
fi
