# dotfiles

## installation

```sh
# Nix Installation
sh <(curl -L https://nixos.org/nix/install) --daemon
sh <(curl -L https://nixos.org/nix/install) # macOS

# Clone this dotfiles repository
nix shell nixpkgs#git nixpkgs#gh nixpkgs#ghq --extra-experimental-features nix-command --extra-experimental-features flakes
gh auth login
ghq get kaitosawada/dotfiles
exit

# Apply this home.nix
cd ~/ghq/github.com/kaitosawada/dotfiles
# init --switchでファイル参照できたらいいんだけど？またはinit必要ないかも？
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- init --switch
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch -f home.nix -b backup
exec $SHELL -l
```
