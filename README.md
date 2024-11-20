# dotfiles

## installation

### ubuntu / MacOS

```sh
# nixのインストール
sudo mkdir /nix
sudo chown -R $USER /nix
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh

# 一時的なgithubの導入からdotfilesをclone
nix shell nixpkgs#git nixpkgs#gh nixpkgs#ghq --extra-experimental-features nix-command --extra-experimental-features flakes
gh auth login
ghq get kaitosawada/dotfiles
exit

# home-managerのインストール
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# home.nixの適用
cd ~/ghq/github.com/kaitosawada/dotfiles
home-manager switch -f home.nix -b backup
exec $SHELL -l
```
