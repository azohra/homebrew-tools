# Contributing

This repository is the `azohra/tools` Homebrew tap. Changes to `main` are
available to Homebrew immediately, so keep each package change and its proof in
the same commit.

Formulae live at the repository root. Casks live in `Casks/`. The Orca cask
also publishes `api/cask/orca.json` for installers that consume tap metadata
instead of evaluating cask Ruby.

## Check a change

Install the pinned Ruby version, stage the files you intend to commit, and run
the repository check:

```sh
mise install
git add <files>
mise run check
```

The check refuses unstaged tracked changes. It checks Ruby syntax, regenerates
the Orca metadata, and runs `brew style` against an isolated copy of the Git
index.

Do not run `brew tap` or `brew untap` against this checkout. Homebrew may
associate installed casks with any tap that carries their token, and a forced
untap can uninstall the real application. On a disposable machine, run the
installation checks through their isolated tap:

```sh
mise run check:install-formulas
mise run check:install-gopro-yank
mise run check:install-orca
```

CI runs the same verbs.

## Release updates

Scheduled workflows call `mise run update:gopro-yank` and `mise run
update:orca` to propose release updates. Those tasks push a branch and open or
update a pull request; they are not local checks.

The Orca updater copies version and checksum fields from the upstream cask. It
refuses when other cask behavior changes; review those changes by hand.
Regenerate `api/cask/orca.json` with `./scripts/orca-api-json.sh`; do not edit
the generated file.

The local Orca metadata exists because the upstream tap does not publish
`api/cask/orca.json`. Retire the mirror after
[stablyai/homebrew-orca#237](https://github.com/stablyai/homebrew-orca/issues/237)
is resolved and a metadata-based install works from `stablyai/orca`.
