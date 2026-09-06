#!/bin/sh
set -eu

repository=azohra/yaml.sh
version=${1:-}
if [ -n "$version" ]; then
  tag="v${version#v}"
else
  tag=$(gh api "repos/$repository/releases/latest" --jq .tag_name)
fi

printf '%s\n' "$tag" | grep -Eq '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$' || exit 1
[ "$(gh release view "$tag" --repo "$repository" --json isDraft,isPrerelease --jq '.isDraft == false and .isPrerelease == false')" = true ] || exit 1
scratch=$(mktemp -d "${TMPDIR:-/tmp}/ysh-formula.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
gh release download "$tag" --repo "$repository" --pattern ysh --pattern ysh.sha256 --dir "$scratch"
expected=$(sed -nE 's/^([0-9a-f]{64})  ysh$/\1/p' "$scratch/ysh.sha256")
[ ${#expected} -eq 64 ] || { echo 'release checksum is invalid' >&2; exit 1; }
actual=$(shasum -a 256 "$scratch/ysh" | cut -d' ' -f1)
[ "$actual" = "$expected" ] || { echo 'release bytes do not match the checksum' >&2; exit 1; }
formula="$scratch/ysh.rb"
sed -E \
  -e "s@/releases/download/v[0-9]+[.][0-9]+[.][0-9]+/ysh@/releases/download/$tag/ysh@" \
  -e "s@^  sha256 \"[0-9a-f]+\"@  sha256 \"$actual\"@" ysh.rb > "$formula"
if cmp -s "$formula" ysh.rb; then
  echo "YAML.sh formula is already current"
  exit 0
fi

# One branch per formula, rebuilt from main on every run, so a new release
# rewrites the open proposal instead of opening another pull request beside it.
branch=automation/ysh
title="Update YAML.sh to ${tag#v}"
body="Updates the YAML.sh formula from the verified release asset for $tag."

git fetch origin main "$branch" 2>/dev/null || git fetch origin main
git switch -C "$branch" origin/main
cp "$formula" ysh.rb
git add ysh.rb
git -c user.name="azohra-bosun[bot]" \
  -c user.email="325107280+azohra-bosun[bot]@users.noreply.github.com" \
  commit -m "$title"

if git rev-parse --verify -q "refs/remotes/origin/$branch" >/dev/null &&
  git diff --quiet "origin/$branch" HEAD; then
  echo "YAML.sh ${tag#v} is already proposed on $branch"
  exit 0
fi

git push --force-with-lease --set-upstream origin "$branch"

if gh pr list --head "$branch" --state open --json url --jq '.[0].url' | grep -q .; then
  gh pr edit "$branch" --title "$title" --body "$body"
else
  gh pr create --base main --head "$branch" --title "$title" --body "$body"
fi
