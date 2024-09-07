# dotfiles

## installation

### ubuntu

```sh
# nixのインストール
sudo chown -R $USER /nix
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh

# nix-channelの追加
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install


# git, gh, go, ghqのインストール
nix-env -iA nixpkgs.git nixpkgs.gh nixpkgs.go nixpkgs.ghq nixpkgs.gnumake nixpkgs.direnv nixpkgs.neovim nixpkgs.zsh

# githubにログイン
gh auth login

# dotfilesをクローン
ghq get kaitosawada/dotfiles
cd $(ghq root)/github.com/kaitosawada/dotfiles

chsh -s ~/.nix-profile/bin/zsh
```

zshに変更するために再ログイン

```sh
```

