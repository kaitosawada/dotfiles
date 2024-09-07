SCRIPT_DIR="$(pwd)"

ln -fnsv .zshrc ~

mkdir "$HOME/.config/nvim"
cp -rs "${SCRIPT_DIR}"/nvim/* "$HOME/.config/nvim"

rm -rf "$HOME/.config/home-manager"
mkdir "$HOME/.config/home-manager"
cp -rs "${SCRIPT_DIR}"/home-manager/* "$HOME/.config/home-manager"
