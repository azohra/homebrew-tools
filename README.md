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

## Config

Converge an Apple Silicon Mac from a configuration repository.

```sh
brew install --cask azohra/tools/config
```

Homebrew supplies the release executable. Run `config bootstrap` explicitly to
set up a machine; Config then maintains its own command at `~/.local/bin/config`.
Installing or upgrading this cask does not run machine setup.

[Config documentation](https://github.com/azohra/config)

## op-agent

Resolve and cache 1Password secrets for command-line tasks.

```sh
brew install --cask azohra/tools/op-agent
```

Supports Apple Silicon macOS and AMD64/ARM64 Linux. Homebrew also installs the
1Password CLI. Run `op-agent setup` explicitly to configure credentials and the
mise plugin.

[op-agent documentation](https://github.com/azohra/op-agent)

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

The daily Update packages workflow checks upstream releases and proposes package
updates through the same `mise run update:<package>` tasks used locally. It
maintains one Bosun PR per package. Publication in the source repository always
precedes a tap update.
