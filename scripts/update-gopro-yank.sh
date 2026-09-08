#!/bin/sh
set -eu

repository=azohra/gopro-yank
version=${1:-}
if [ -n "$version" ]; then
  tag="v${version#v}"
else
  tag=$(gh api "repos/$repository/releases/latest" --jq .tag_name)
fi

printf '%s\n' "$tag" | grep -Eq '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$' || exit 1
[ "$(gh release view "$tag" --repo "$repository" --json isDraft,isPrerelease --jq '.isDraft == false and .isPrerelease == false')" = true ] || exit 1

scratch=$(mktemp -d "${TMPDIR:-/tmp}/gopro-yank-cask.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
gh release download "$tag" --repo "$repository" --pattern gopro-yank.rb --pattern checksums.txt --dir "$scratch"

cask="$scratch/gopro-yank.rb"
expected=$(awk '$2 == "gopro-yank.rb" { print $1 }' "$scratch/checksums.txt")
[ ${#expected} -eq 64 ] || { echo 'release checksum is invalid' >&2; exit 1; }
actual=$(shasum -a 256 "$cask" | cut -d' ' -f1)
[ "$actual" = "$expected" ] || { echo 'release bytes do not match the checksum' >&2; exit 1; }
grep -Fxq "  version \"${tag#v}\"" "$cask" || { echo 'cask version does not match the release' >&2; exit 1; }

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

cp "$cask" Casks/gopro-yank.rb
echo "Updated gopro-yank package files"
