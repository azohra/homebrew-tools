# Azohra tools for Homebrew

Small, useful tools—one command away.

## YAML.sh

Query and update YAML anywhere with `/bin/sh` and AWK.

```sh
brew install azohra/tools/ysh
```

One readable executable. No package runtime or hidden binary.

[Meet YAML.sh →](https://yaml.azohra.com)

## GoPro Yank

Bring your GoPro library home and know nothing is missing.

```sh
brew install --cask azohra/tools/gopro-yank
```

Homebrew downloads the ready-to-run app for your computer. No Go toolchain or
developer setup required.

[Meet GoPro Yank →](https://github.com/azohra/gopro-yank)

## Orca

Install [Orca](https://onorca.dev/) where the upstream tap can't reach.

```sh
brew install --cask azohra/tools/orca
```

Mirrors the upstream `stablyai/orca` cask and publishes the generated API
metadata (`api/cask/orca.json`) alongside it, so tools that install casks
from tap metadata — such as mise's `brew-cask:` backend — can install Orca
too. A daily workflow opens a PR when upstream cuts a release.

## Lyra

Encrypt files from the command line.

```sh
brew install azohra/tools/lyra
```

[Meet Lyra →](https://github.com/azohra/lyra)
