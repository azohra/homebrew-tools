# Contributing

This repository is the `azohra/tools` Homebrew tap. Changes to `main` are
available to Homebrew immediately, so keep each package change and its proof in
the same commit.

Formulae live at the repository root. Casks live in `Casks/`. The Orca cask
also publishes `api/cask/orca.json` for installers that consume tap metadata
instead of evaluating cask Ruby.

## Check a change

Install the pinned toolchain and run the repository check:

```sh
mise install
mise run check
```

The check tests updater behavior, checks Ruby syntax and runs `brew style`
on an isolated copy of the working files. Changes to the Orca
cask or its metadata must also pass `mise run check:orca-api`; CI runs that
arm64 macOS proof before installing the cask.

Do not run `brew tap` or `brew untap` against this checkout. Homebrew may
associate installed casks with any tap that carries their token, and a forced
untap can uninstall the real application. On a disposable machine, run the
installation checks through their isolated tap after staging the intended files:

```sh
mise run check:install-formulas
mise run check:install-cask -- gopro-yank
mise run check:install-cask -- orca
mise run check:install-cask -- config
mise run check:install-cask -- op-agent
```

CI runs the same verbs.

## Release updates

`mise run update:<package>` edits local package files for `gopro-yank`, `ysh`,
`orca`, `config` or `op-agent`. Review and check the diff before committing it.
The scheduled or manually dispatched Update packages workflow runs those same
tasks, then opens or refreshes one PR per package with Bosun. Only that PR step
needs write credentials; the tasks do not switch branches, commit or push.

Config and op-agent updates use Homebrew's `bump-cask-pr --write-only` command
on a temporary copy of the working cask. Homebrew downloads the release archives
and updates their checksums; the task copies the result back without Git writes
in the checkout.

PR checks cover formula installation and any affected cask installation. The
required Check result includes those proofs, and strict up-to-date enforcement
prevents merging a stale result. Merging does not repeat the installation jobs.

The Orca updater copies version and checksum fields from the upstream cask. It
refuses when other cask behavior changes; review those changes by hand.
Regenerate `api/cask/orca.json` with `./scripts/orca-api-json.sh`; do not edit
the generated file.

The local Orca metadata exists because the upstream tap does not publish
`api/cask/orca.json`. Retire the mirror after
[stablyai/homebrew-orca#237](https://github.com/stablyai/homebrew-orca/issues/237)
is resolved and a metadata-based install works from `stablyai/orca`.
