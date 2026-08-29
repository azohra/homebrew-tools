#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

proof=${1:-}
case "$proof" in
  formulas)
    [ "$#" -eq 1 ] || {
      echo "check:install-formulas: refusing — expected no arguments" >&2
      exit 1
    }
    task=check:install-formulas
    ;;
  cask)
    [ "$#" -eq 2 ] || {
      echo "check:install-cask: refusing — expected one cask token" >&2
      exit 1
    }
    token=$2
    case "$token" in
      "" | -* | *- | *[!a-z0-9-]*)
        echo "check:install-cask: refusing — invalid cask token: $token" >&2
        exit 1
        ;;
    esac
    [ -f "Casks/$token.rb" ] || {
      echo "check:install-$token: refusing — Casks/$token.rb does not exist" >&2
      exit 1
    }
    task="check:install-$token"
    ;;
  *)
    echo "check:install: refusing — expected formulas or cask <token>" >&2
    exit 1
    ;;
esac

command -v brew >/dev/null || {
  echo "$task: refusing — Homebrew is not installed" >&2
  exit 1
}
git diff --quiet || {
  echo "$task: refusing — tracked changes are not staged" >&2
  exit 1
}

export HOMEBREW_NO_AUTO_UPDATE=1
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_COMMON_DIR GIT_OBJECT_DIRECTORY GIT_PREFIX

brew_repository=$(brew --repository)
case "$brew_repository" in
  /*) ;;
  *)
    echo "$task: refusing — Homebrew returned an invalid repository path" >&2
    exit 1
    ;;
esac
[ -d "$brew_repository" ] || {
  echo "$task: refusing — Homebrew repository does not exist: $brew_repository" >&2
  exit 1
}

taproot="$brew_repository/Library/Taps/azohra-install"
tapdir="$taproot/homebrew-tools-install"
[ ! -e "$taproot" ] && [ ! -L "$taproot" ] || {
  echo "$task: refusing — $taproot already exists" >&2
  exit 1
}
trap 'rm -rf "$taproot"' EXIT
mkdir -p "$tapdir"
git checkout-index -a --prefix="$tapdir/"
git -C "$tapdir" init -q
git -C "$tapdir" add -A
git -C "$tapdir" -c user.email=check@local -c user.name=check commit -q -m staged

if [ "$proof" = formulas ]; then
  for formula in *.rb; do
    [ -f "$formula" ] || continue
    token=${formula%.rb}
    brew list --formula "$token" >/dev/null 2>&1 && {
      echo "$task: refusing — $token is already installed" >&2
      exit 1
    }
    brew install --formula "azohra-install/tools-install/$token"
    brew test "azohra-install/tools-install/$token"
  done
  exit
fi

brew list --cask "$token" >/dev/null 2>&1 && {
  echo "$task: refusing — $token is already installed" >&2
  exit 1
}
brew install --cask "azohra-install/tools-install/$token"
"$token" --version
