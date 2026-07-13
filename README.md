# dotfiles

Personal Linux configuration.

## Requirements

- Git
- GNU Stow
- [`mise`](https://mise.jdx.dev/)
- Arch Linux or Void Linux

## Deploy dotfiles

```sh
stow -d home -t "$HOME" .
```

## Install packages

```sh
./install-packages.sh
```

The script detects the distribution and installs every package listed under:

- `packages/_common/`
- `packages/<distro>/`

## Install system environment variables

```sh
./install-env.sh
```

Writes required environment variables (e.g. NVIDIA VA-API settings) to `/etc/environment`. Requires a reboot (or new login session) to take effect.

## Install development toolchain

```sh
mise install
```

Installs every tool declared in `~/.config/mise/mise.toml`.

## Update

System packages:

```sh
./install-packages.sh
```

Development tools:

```sh
mise upgrade
```

## First-time setup

```sh
stow -d home -t "$HOME" .
./install-packages.sh
./install-env.sh   
mise install
```
