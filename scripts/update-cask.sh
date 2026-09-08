#!/usr/bin/env bash
set -euo pipefail
package=${1:?Expected config or op-agent}
case "$package" in config|op-agent) ;; *) exit 2 ;; esac
version=${2:-}
if [ -z "$version" ]; then
  version=$(gh release view --repo "azohra/$package" --json tagName --jq .tagName)
fi
version=${version#v}
[[ "$version" =~ ^(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)[.](0|[1-9][0-9]*)$ ]]
[ "$(gh release view "v$version" --repo "azohra/$package" --json isDraft,isPrerelease --jq '.isDraft == false and .isPrerelease == false')" = true ]
cask="Casks/$package.rb"
if grep -Fxq "  version \"$version\"" "$cask"; then
  echo "$package is already current at $version"
  exit 0
fi

# Homebrew's updater requires a tap. Give it a copy of the working cask.
tapdir="$(brew --repository)/Library/Taps/azohra-update/homebrew-tools-update-$package"
[ ! -e "$tapdir" ] && [ ! -L "$tapdir" ] || { echo 'temporary update tap already exists' >&2; exit 1; }
trap 'rm -rf "$tapdir"' EXIT
mkdir -p "$tapdir/Casks"
git init -q "$tapdir"
cp "$cask" "$tapdir/Casks/"
brew bump-cask-pr --write-only --no-audit --version "$version" "azohra-update/tools-update-$package/$package"
cp "$tapdir/Casks/$package.rb" "$cask"
