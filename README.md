# dotfiles

## installation

home-managerはnix profileで管理しています。

```sh
# Nix Installation
sh <(curl -L https://nixos.org/nix/install) # (linux) --daemon

# Clone this dotfiles repository
nix shell nixpkgs#gh nixpkgs#ghq --extra-experimental-features "nix-command flakes"
gh auth login # ssh?
ghq get kaitosawada/dotfiles
# home-manager switchでも必要かも？
exit

# Apply home.nix
nix profile install nixpkgs#home-manager
home-manager --extra-experimental-features "nix-command flakes" switch --flake ".#$(whoami)-x86_64-linux" -b backup
exec $SHELL -l
```
