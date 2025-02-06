# dotfiles

## installation

home-managerはnix profileで管理しています。

```sh
# Nix Installation
sh <(curl -L https://nixos.org/nix/install) # (linux) --daemon
# linuxの場合は一度exit

# Clone this dotfiles repository
# linuxの場合はnixpkgs#gitも
nix shell nixpkgs#gh nixpkgs#ghq --extra-experimental-features "nix-command flakes"
gh auth login # ssh
ghq get ssh://git@github.com/kaitosawada/dotfiles.git
# home-manager switchでも必要かも？
exit

# Apply home.nix
export NIXPKGS_ALLOW_UNFREE=1
nix profile install nixpkgs#home-manager --extra-experimental-features "nix-command flakes"
cd ~/ghq/github.com/kaitosawada/dotfiles
home-manager --extra-experimental-features "nix-command flakes" switch --flake ".#$(whoami)-x86_64-linux" -b backup
exec $SHELL -l
```
