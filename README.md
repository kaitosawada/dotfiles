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

## nixos

シークレット管理に sops-nix を使用しています。age 秘密鍵は Bitwarden に保存されています。

### セットアップ

```sh
# 1. Bitwarden から age 秘密鍵を取り出して配置
sudo mkdir -p /var/lib/sops-nix
sudo sh -c 'echo "AGE-SECRET-KEY-XXXXX" > /var/lib/sops-nix/key.txt'
sudo chmod 600 /var/lib/sops-nix/key.txt

# 2. hardware-configuration.nix をリポジトリにコピー（初回のみ）
cp /etc/nixos/hardware-configuration.nix ~/ghq/github.com/kaitosawada/dotfiles/nixos/

# 3. このflakeからシステムをリビルド
sudo nixos-rebuild switch --flake ~/ghq/github.com/kaitosawada/dotfiles#nixos
```

### シークレットの編集・追加

シークレットの編集には、ローカルに age 秘密鍵が必要です。

```sh
# 秘密鍵を配置（編集時のみ必要）
mkdir -p ~/.config/sops/age
echo "AGE-SECRET-KEY-XXXXX" > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt

# シークレットを編集（エディタが開く）
nix-shell -p sops --run "sops nixos/secrets/secrets.yaml"
```

シークレットファイルの形式（YAML）:

```yaml
user-password: "$y$j9T$..."  # mkpasswd で生成したハッシュ
some-api-key: "secret-value"
```

configuration.nix での使用例:

```nix
sops.secrets.some-api-key = {};  # シークレットを定義

# ファイルパスとして参照
environment.etc."some-config".text = ''
  API_KEY_FILE=${config.sops.secrets.some-api-key.path}
'';
```

### パスワードハッシュの生成

```sh
nix-shell -p mkpasswd --run "mkpasswd -m yescrypt"
```
