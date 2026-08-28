# Azohra tools for Homebrew

Install Azohra command-line tools and applications through Homebrew.

The packages below have dedicated install instructions. Older formulas remain
in the tap for existing installations.

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

This tap tracks the upstream `stablyai/orca` cask and publishes generated API
metadata in `api/cask/orca.json`. Metadata-based installers, including mise's
`brew-cask:` backend, can install Orca without evaluating cask Ruby. A daily
workflow proposes new releases.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) before changing a formula or cask.
