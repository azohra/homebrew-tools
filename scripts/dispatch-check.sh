#!/bin/sh
set -eu

[ "$#" -eq 1 ] || {
  echo "dispatch-check: refusing — expected an automation branch" >&2
  exit 2
}

branch=$1
case "$branch" in
  automation/orca | automation/gopro-yank) ;;
  *)
    echo "dispatch-check: refusing — unexpected branch: $branch" >&2
    exit 2
    ;;
esac

# The updater token has actions:write specifically for this dispatch. Running
# the existing Check by ref avoids the token-originated PR event restriction.
gh workflow run check.yml --ref "$branch" --repo azohra/homebrew-tools
