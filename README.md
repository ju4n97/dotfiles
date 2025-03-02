# Dotfiles

This dotfiles are managed using [stow](https://www.gnu.org/software/stow/).

## Replicate

```sh
git clone --depth=1 https://github.com/ju4n97/dotfiles.git ~/dotfiles

# Or with submodules
git clone --depth=1 --recurse-submodules https://github.com/ju4n97/dotfiles.git ~/dotfiles
```

## Create symlinks

```sh
sudo pacman -S stow
cd ~/dotfiles && stow .
```

## Install packages

```sh
sudo pacman -S --needed $(cat ~/pacman.txt)
```

## Install AUR packages

```sh
yay -S --needed $(cat ~/aur.txt)
```

## Setup dotfiles

```sh
cd ~ && sudo ./setup.sh
```

## Setup pacman hooks

```sh
cd ~ && ./setup-hooks.sh
```
