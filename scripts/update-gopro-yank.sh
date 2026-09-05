#!/bin/sh
set -eu

repository=azohra/gopro-yank
version=${1:-}
if [ -n "$version" ]; then
  tag="v${version#v}"
else
  tag=$(gh api "repos/$repository/releases/latest" --jq .tag_name)
fi

scratch=$(mktemp -d "${TMPDIR:-/tmp}/gopro-yank-cask.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
gh release download "$tag" --repo "$repository" --pattern gopro-yank.rb --dir "$scratch"

cask="$scratch/gopro-yank.rb"
if ! grep -Fq 'cask "gopro-yank" do' "$cask"; then
  echo "downloaded file is not the GoPro Yank cask" >&2
  exit 1
fi
if ! grep -Fq "/releases/download/v#{version}/" "$cask"; then
  echo "downloaded cask does not reference release assets" >&2
  exit 1
fi
if cmp -s "$cask" Casks/gopro-yank.rb; then
  echo "GoPro Yank cask is already current"
  exit 0
fi

# One branch per cask, rebuilt from main on every run, so a new release
# rewrites the open proposal instead of opening another pull request beside it.
branch=automation/gopro-yank
title="Update GoPro Yank to ${tag#v}"
body="Updates the GoPro Yank cask from the verified release asset for $tag."

git fetch origin main "$branch" 2>/dev/null || git fetch origin main
git switch -C "$branch" origin/main
cp "$cask" Casks/gopro-yank.rb
git add Casks/gopro-yank.rb
git -c user.name="github-actions[bot]" \
  -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit -m "$title"

if git rev-parse --verify -q "refs/remotes/origin/$branch" >/dev/null &&
  git diff --quiet "origin/$branch" HEAD; then
  echo "GoPro Yank ${tag#v} is already proposed on $branch"
  exit 0
fi

git push --force-with-lease --set-upstream origin "$branch"

if gh pr list --head "$branch" --state open --json url --jq '.[0].url' | grep -q .; then
  gh pr edit "$branch" --title "$title" --body "$body"
else
  gh pr create --base main --head "$branch" --title "$title" --body "$body"
fi
