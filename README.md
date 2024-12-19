# dotfiles

## installation

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
# init --switchでファイル参照できたらいいんだけど？またはinit必要ないかも？
# nix run home-manager/master --extra-experimental-features "nix-command flakes" -- init --switch
nix run home-manager/master --extra-experimental-features "nix-command flakes" -- switch -f ~/ghq/github.com/kaitosawada/dotfiles/home.nix -b backup
exec $SHELL -l
```
