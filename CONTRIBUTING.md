# Contributing

This repository is the `azohra/tools` Homebrew tap. Changes to `main` are
available to Homebrew immediately, so keep each package change and its proof in
the same commit.

Formulae live at the repository root. Casks live in `Casks/`.

## Check a change

Install the pinned toolchain and run the repository check:

```sh
mise install
mise run check
```

`check` runs `lint`, which checks Ruby syntax and runs `brew style` on an
isolated copy of the working files.

Do not run `brew tap` or `brew untap` against this checkout. Homebrew may
associate installed casks with any tap that carries their token, and a forced
untap can uninstall the real application. On a disposable machine, run the
installation checks through their isolated tap after staging the intended files:

```sh
mise run check:install-formulas
mise run check:install-cask -- gopro-yank
mise run check:install-cask -- config
mise run check:install-cask -- op-agent
```

CI runs the same verbs.

## Release updates

A release of gopro-yank, config, op-agent or YAML.sh opens a pull request here
with the generated cask or formula, and this repository's checks gate it.

PR checks cover formula installation and any affected cask installation. The
required Check result includes those proofs, and strict up-to-date enforcement
prevents merging a stale result. Merging does not repeat the installation jobs.
