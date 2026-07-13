# dotfiles

Personal Linux configuration.

## Layout

```text
.
├── home/                  # Files deployed to $HOME with GNU Stow
├── packages/              # Package lists
│   ├── _common/
│   ├── arch/
│   └── void/
├── mise.toml              # Development tools and runtimes
├── install-packages.sh
└── install-dev.sh
```

## Requirements

- Git
- GNU Stow
- [`mise`](https://mise.jdx.dev/)
- Arch Linux or Void Linux

## Install packages

```sh
./install-packages.sh
```

The script detects the distribution and installs every package listed under:

- `packages/_common/`
- `packages/<distro>/`

## Install development toolchain

```sh
./install-toolchain.sh
```

Installs every tool declared in `mise.toml`.

## Deploy dotfiles

```sh
stow -d home -t "$HOME" .
```

## Update

System packages:

```sh
./install-packages.sh
```

Development tools:

```sh
mise upgrade
```