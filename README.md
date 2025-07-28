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

## Install base packages

```sh
sudo pacman -S --needed $(cat ~/pacman.base.txt)
```

## Install base AUR packages

```sh
yay -S --needed $(cat ~/aur.base.txt)
```

## Setup

```sh
chmod +x ~/dotfiles.sh && ~/dotfiles.sh --reflector --fonts --swap --firewall --bluetooth --docker --pacman-hooks --devtools --zsh --xdg-user-dirs --xfce4-shortcuts --xfce4-middle-button --wacom
```
