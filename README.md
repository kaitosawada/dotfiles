# dotfiles

## installation

home-managerはnix profileで管理しています。

```sh
# Nix Installation
sh <(curl -L https://nixos.org/nix/install) # macos
sh <(wget -qO- https://nixos.org/nix/install) --daemon # linux
# linuxの場合は一度exit

# Clone this dotfiles repository
# linuxの場合はnixpkgs#gitも
nix shell nixpkgs#gh nixpkgs#ghq nixpkgs#git --extra-experimental-features "nix-command flakes"
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

## docker

colimaを使っています。

```sh
sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock
```

## llama-server

llama.vimで補完してます。

```sh
llama-server --fim-qwen-3b-default
llama-server --fim-qwen-7b-default
```
