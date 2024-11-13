# dotfiles

## installation

### ubuntu / MacOS

```sh
# nixのインストール
sudo mkdir /nix
sudo chown -R $USER /nix
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh

# nix-channelの追加
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# git, gh, go, ghqのインストール
nix-env -iA nixpkgs.git nixpkgs.gh nixpkgs.go nixpkgs.ghq nixpkgs.zsh

# githubにログイン
gh auth login

# dotfilesをクローン
ghq get kaitosawada/dotfiles
cd $(ghq root)/github.com/kaitosawada/dotfiles

# 多分nix-envをアンインストールする必要がある
# 多分すでに.bashrcがあるので-h backupする必要がある
nix-env -e git gh go ghq zsh
home-manager switch -f home.nix
exec $SHELL -l
```
