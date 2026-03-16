# dotfiles

## installation

home-manager自体はhome-managerではなくnix profileで手動で管理しています。

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
exit

# Apply home.nix
export NIXPKGS_ALLOW_UNFREE=1
nix profile install nixpkgs#home-manager --extra-experimental-features "nix-command flakes"
cd ~/ghq/github.com/kaitosawada/dotfiles
home-manager --extra-experimental-features "nix-command flakes" switch --flake ".#$(whoami)-x86_64-linux" -b backup --impure
exec $SHELL -l
```

## docker

colimaを使っています。手動でcolimaを起動してください。
docker.sockをリンクする必要があるかもしれません。

```sh
sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock
```

## nix profileでunfree packageを使う

```sh
nix registry add nixpkgs github:numtide/nixpkgs-unfree/nixos-unstable
```

## sops-nix によるシークレット管理

age 秘密鍵は Bitwarden に保存されています。

### セットアップ

```sh
# Bitwarden から age 秘密鍵を取り出して配置
bw login  # Bitwarden にログイン (or `bw unlock`)
mkdir -p ~/.config/sops/age
bw get item "sops_age_secret_key" | jq -r '.notes' > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

### home-manager 用シークレット

`secrets/home.yaml` で管理。`sops.templates` を使って設定ファイルにシークレットを注入します。

```sh
# シークレットの編集（エディタが開く）
nix-shell -p sops --run "sops secrets/home.yaml"
```

### NixOS 用シークレット

```sh
# NixOS 用の age 秘密鍵を配置
sudo mkdir -p /var/lib/sops-nix
sudo sh -c 'echo "AGE-SECRET-KEY-XXXXX" > /var/lib/sops-nix/key.txt'
sudo chmod 600 /var/lib/sops-nix/key.txt

# シークレットの編集
nix-shell -p sops --run "sops nixos/secrets/secrets.yaml"
```
