# dotfiles

## installation

### ubuntu

```bash
sudo apt update
sudo apt install git zsh

chsh -s $(which zsh)
# 適宜ユーザーの設定を行う
```

zshに変更するために再ログイン

```sh
# nixのインストール
sudo chown -R $USER /nix
curl -L https://nixos.org/nix/install | sh
echo '. ~/.nix-profile/etc/profile.d/nix.sh' >> ~/.zshrc
source ~/.zshrc

# git, gh, go, ghqのインストール
nix-env -iA nixpkgs.git nixpkgs.gh nixpkgs.go nixpkgs.ghq

# githubにログイン
gh auth login

# dotfilesをクローン
ghq get kaitosawada/dotfiles
cd $(ghq root)/github.com/kaitosawada/dotfiles
```

